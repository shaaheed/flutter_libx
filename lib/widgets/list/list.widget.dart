import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'list.bloc.dart';
import '../dialogs/delete.dialog.dart';
import '../circular_progress.dart';
import '../no_data.dart';
import '../../models/model.dart';
import '../../blocs/event.dart';
import '../../object_factory.dart';
import '../../extensions/string.extension.dart';
import '../../../helpers/popup.dart';
import '../../../enums/display_as.dart';

abstract class StatefulList<T extends Model<T>> extends StatefulWidget {
  final ListBloc<T> bloc;
  final ScrollController? controller;
  final ObjectFactory<StatefulListState<T, StatefulList<T>>>? state;
  final DisplayAs displayAs;
  final Object? arguments;
  final StatefulListData<T> data = StatefulListData<T>();
  final bool callOnLoadOnInit;

  StatefulList(
    this.bloc, {
    this.state,
    this.displayAs = DisplayAs.listView,
    this.controller,
    this.callOnLoadOnInit = true,
    this.arguments,
    Key? key,
  }) : super(key: key) {
    data.state = state ??
        ObjectFactory<StatefulListState<T, StatefulList<T>>>(
          () => StatefulListState<T, StatefulList<T>>(),
        );
    data.controller = controller ??
        ScrollController(
          keepScrollOffset: true,
        );
  }

  String? getAddPageRoute() => null;

  String? getEditPageRoute() => getAddPageRoute();

  bool canShowFloatingActionButton() {
    String? route = getAddPageRoute();
    return displayAs != DisplayAs.selectAnItem &&
        route != null &&
        route.isNotEmpty;
  }

  T? getDefaultItem() => null;

  Widget itemBuilder(BuildContext context, T model);

  void initState() {}

  BuildContext? get context => data.state.getCurrent().context;

  void refresh(Object? arguments) => data.state.getCurrent().refresh(arguments);

  void updateItem(T item) => bloc.updateItem(item);

  void addItem(T item) => bloc.addItem(item);

  Future<bool> deleteItem(T item) => Future.value(false);

  List<T> getItems() => bloc.items;

  T getItem(int index) => bloc.items[index];

  int getItemCount() => bloc.items.length;

  Future<void> onPullRefresh() => Future.value();

  ScrollController? getController() => data.controller;

  bool isListViewEvent(Event? event) => false;

  Widget getEmptyWidget(BuildContext context) => const NoData();

  Widget getListView(
    BuildContext context,
    Event event,
  ) {
    int? itemCount = getItemCount();
    return ListView.separated(
      controller: getController(),
      itemBuilder: (context, index) {
        T item = getItem(index);
        if (displayAs == DisplayAs.listView) {
          return Slidable(
            startActionPane: ActionPane(
              motion: const ScrollMotion(),
              children: [
                SlidableAction(
                  onPressed: (BuildContext context) async {
                    String? routeName = getEditPageRoute();
                    if (routeName != null) {
                      var result = await Navigator.pushNamed(
                        context,
                        routeName,
                        arguments: item,
                      );
                      if (result is T) updateItem(result);
                    }
                  },
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.grey,
                  icon: Icons.edit_outlined,
                  label: 'Edit'.i18n(context),
                ),
                const SizedBox(
                  height: 25,
                  child: VerticalDivider(),
                ),
                SlidableAction(
                  onPressed: (BuildContext context) async {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return DeleteDialog(
                          context,
                          () async {
                            bool deleted = await deleteItem(item);
                            if (deleted) bloc.deleteItem(item);
                          },
                        );
                      },
                    );
                  },
                  backgroundColor: Colors.white, //Colors.red,
                  foregroundColor: Colors.grey,
                  icon: Icons.delete_outline_rounded,
                  label: 'Delete'.i18n(context),
                ),
              ],
            ),
            child: itemBuilder(context, item),
          );
        }
        return itemBuilder(context, item);
      },
      separatorBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(left: 65.0),
          child: const Divider(height: 1),
        );
      },
      itemCount: itemCount,
    );
  }

  @override
  // ignore: no_logic_in_create_state
  State<StatefulWidget> createState() => data.state.createNew();

  FloatingActionButtonLocation? getFloatingActionButtonLocation() =>
      FloatingActionButtonLocation.centerFloat;

  FloatingActionButton? getFloatingActionButton(BuildContext context) {
    if (canShowFloatingActionButton()) {
      return FloatingActionButton(
        onPressed: () async {
          String? routeName = getAddPageRoute();
          if (routeName != null) {
            var args = await Navigator.pushNamed(context, routeName);
            if (args is T) addItem(args);
          }
        },
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        child: const Icon(Icons.add),
      );
    }
    return null;
  }

  void handleItemTap(BuildContext context, T item) {
    if (displayAs == DisplayAs.selectAnItem) Navigator.pop(context, item);
  }

  void handleItemLongPress(
    BuildContext context,
    T item,
  ) {
    String? routeName = getEditPageRoute();
    if (routeName != null && displayAs == DisplayAs.listView) {
      Popup.editDeleteMenu(
        context,
        item,
        routeName,
        (args) {
          if (args is T) updateItem(args);
        },
        () async {
          bool deleted = await deleteItem(item);
          if (deleted) bloc.deleteItem(item);
        },
      );
    }
  }

  Widget build(BuildContext context, Widget? widget) {
    return Stack(
      children: [
        if (data.state.getCurrent().loading) const CircularProgress(),
        StreamBuilder<Event>(
          stream: bloc.stream,
          initialData: LoadingEvent(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var event = snapshot.data;
              if (event is LoadingEvent) {
                return const CircularProgress();
              } else if (isListViewEvent(event) ||
                  event is DataEvent<List<T>>) {
                if ((event as DataEvent<List<T>>).data.isEmpty) {
                  return getEmptyWidget(context);
                }
                return RefreshIndicator(
                  onRefresh: onPullRefresh,
                  child: Scrollbar(
                    controller: data.controller,
                    child: getListView(context, event),
                  ),
                );
              }
            }
            return getEmptyWidget(context);
          },
        ),
      ],
    );
  }

  void dispose() => data.state.dispose();
}

class StatefulListState<T extends Model<T>, TWidget extends StatefulList<T>>
    extends State<TWidget> {
  bool loading = false;

  @override
  void initState() {
    super.initState();
    widget.initState();

    if (widget.callOnLoadOnInit) {
      widget.bloc.load(arguments: widget.arguments);
    }

    ScrollController? scrollController = widget.data.controller;
    scrollController?.addListener(() async {
      if (widget.bloc.hasMore && scrollController.position.extentAfter <= 0) {
        setState(() {
          loading = true;
        });
        await widget.bloc.load(arguments: widget.arguments);
        setState(() {
          loading = false;
        });
      }
    });
  }

  reset() => widget.bloc.reset();

  void refresh(Object? arguments) =>
      Future.delayed(Duration.zero, () => setState(() {}));

  @override
  Widget build(BuildContext context) => widget.build(context, null);

  @override
  void dispose() {
    widget.dispose();
    widget.data.controller?.dispose();
    super.dispose();
  }
}

class StatefulListData<T extends Model<T>> {
  late ObjectFactory<StatefulListState<T, StatefulList<T>>> state;
  ScrollController? controller;
}

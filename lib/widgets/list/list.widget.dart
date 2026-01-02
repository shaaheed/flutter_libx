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
import '../../services/repository.service.dart';
import '../../services/app.service.dart';

abstract class StatefulList<T extends Model<T>> extends StatefulWidget {
  final ListBloc<T>? bloc;
  final RepositoryService<T>? repository;
  final ScrollController? controller;
  final ObjectFactory<StatefulListState<T, StatefulList<T>>>? state;
  final DisplayAs displayAs;
  final Object? arguments;
  final StatefulListData<T> data = StatefulListData<T>();
  final bool callOnLoadOnInit;

  StatefulList({
    this.bloc,
    this.repository,
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

  String? getViewPageRoute() => null;

  String? getAddPageRoute() => null;

  Object? getArguments() => arguments;

  String? getEditPageRoute() => getAddPageRoute();

  Widget? getSlidableWidget(BuildContext context, T? item) {
    return Slidable(
      startActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (BuildContext context) {
              String? routeName = getEditPageRoute();
              if (routeName != null) {
                _navigate(
                  context,
                  routeName,
                  model: item,
                  onSubmit: (T? editedItem) => updateItem(editedItem),
                  onComplete: (Object? result) {
                    if (result is T) bloc?.updateItem(result);
                  },
                );
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
                    () => deleteItem(item),
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
      child: itemBuilder(
        context,
        item,
      ),
    );
  }

  bool canShowFloatingActionButton() {
    String? route = getAddPageRoute();
    return displayAs != DisplayAs.selectAnItem &&
        route != null &&
        route.isNotEmpty;
  }

  T? getDefaultItem() => null;

  Widget itemBuilder(BuildContext context, T? model);

  Widget separatorBuilder(BuildContext context, int index) {
    return Container(
      margin: const EdgeInsets.only(left: 65.0),
      child: const Divider(height: 1),
    );
  }

  void initState() {}

  BuildContext? get context => data.state.getCurrent()?.context;

  void refresh({
    Object? arguments,
  }) =>
      data.state.getCurrent()?.refresh(
            arguments: arguments,
          );

  Future<bool> updateItem(T? item) async {
    if (item != null && repository != null) {
      int _updated = await repository!.update(item);
      return _updated > 0;
    }
    return false;
  }

  Future<bool> addItem(T? item) async {
    if (item != null && repository != null) {
      int _inserted = await repository!.insert(item);
      return _inserted > 0;
    }
    return false;
  }

  Future<bool> deleteItem(T? item) async {
    bool deleted = false;
    if (item != null && repository != null) {
      int _deleted = await repository!.delete(item);
      deleted = _deleted > 0;
      if (deleted && bloc != null) bloc!.deleteItem(item);
    }
    return deleted;
  }

  Future<List<T>?> loadItems({Object? arguments}) async {
    var items = await repository?.list(
      offset: bloc?.offset ?? 0,
      limit: bloc?.limit ?? 10,
      arguments: arguments ?? this.arguments,
    );
    bloc?.addItems(items);
    bloc?.forward();
    return items;
  }

  List<T>? getItems() => bloc?.items;

  T? getItem(int index) => bloc?.items[index];

  int? getItemCount() => bloc?.items.length;

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
        T? item = getItem(index);
        if (displayAs == DisplayAs.listView) {
          Widget? widget = getSlidableWidget(context, item);
          if (widget == null) return itemBuilder(context, item);
          return widget;
        }
        return itemBuilder(context, item);
      },
      separatorBuilder: (context, index) => separatorBuilder(context, index),
      itemCount: itemCount ?? 0,
    );
  }

  @override
  State<StatefulWidget> createState() =>
      // ignore: no_logic_in_create_state
      data.state.createNew() as State<StatefulWidget>;

  FloatingActionButtonLocation? getFloatingActionButtonLocation() =>
      FloatingActionButtonLocation.centerFloat;

  FloatingActionButton? getFloatingActionButton(BuildContext context) {
    if (canShowFloatingActionButton()) {
      return FloatingActionButton(
        onPressed: () {
          String? routeName = getAddPageRoute();
          if (routeName != null) {
            _navigate(
              context,
              routeName,
              model: null,
              onSubmit: (newItem) => addItem(newItem),
              onComplete: (Object? result) {
                if (result is T) bloc?.addItem(result);
              },
            );
          }
        },
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        child: const Icon(Icons.add),
      );
    }
    return null;
  }

  void handleItemTap(BuildContext context, T? item) {
    if (displayAs == DisplayAs.selectAnItem && item != null) {
      Navigator.pop(context, item);
    } else {
      String? routeName = getViewPageRoute();
      if (routeName != null) {
        _navigate(context, routeName, model: item);
      }
    }
  }

  void handleItemLongPress(
    BuildContext context,
    T? item,
  ) {
    String? routeName = getEditPageRoute();
    if (routeName != null && displayAs == DisplayAs.listView) {
      Popup.showPopupMenu<String>(
        context: context,
        offset: AppService.getCurrentOffset(),
        items: [
          Popup.editMenuItem(
            () {
              _navigate(
                context,
                routeName,
                model: item,
                onSubmit: (T? editedItem) => updateItem(editedItem),
                onComplete: (Object? result) {
                  if (result is T) {
                    bloc?.updateItem(result);
                  }
                },
              );
            },
          ),
          Popup.deleteMenuItem(
            context,
            () => deleteItem(item),
          )
        ],
      );
    }
  }

  Widget build(BuildContext context, Widget? widget) {
    var state = data.state.getCurrent();
    return Stack(
      children: [
        if (state == null || state.loading) const CircularProgress(),
        StreamBuilder<Event>(
          stream: bloc?.stream,
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

  void _navigate(
    BuildContext context,
    String route, {
    T? model,
    Future<bool> Function(T? arguments)? onSubmit,
    void Function(Object? arguments)? onComplete,
  }) async {
    var result = await Navigator.pushNamed(
      context,
      route,
      arguments: NavigatorActionArguments<T>(
          action: onSubmit, model: model, arguments: getArguments()),
    );
    onComplete?.call(result);
  }
}

class StatefulListState<T extends Model<T>, TWidget extends StatefulList<T>>
    extends State<TWidget> {
  bool loading = false;

  @override
  void initState() {
    super.initState();
    widget.initState();

    if (widget.callOnLoadOnInit) {
      widget.loadItems();
    }

    ScrollController? scrollController = widget.data.controller;
    scrollController?.addListener(() async {
      if (widget.bloc != null &&
          widget.bloc!.hasMore &&
          scrollController.position.extentAfter <= 0) {
        setState(() {
          loading = true;
        });
        await widget.loadItems();
        setState(() {
          loading = false;
        });
      }
    });
  }

  reset() => widget.bloc?.reset();

  void refresh({Object? arguments}) =>
      Future.delayed(Duration.zero, () => setState(() {}));

  @override
  Widget build(BuildContext context) => widget.build(context, null);

  @override
  void dispose() {
    widget.dispose();
    super.dispose();
  }
}

class StatefulListData<T extends Model<T>> {
  late ObjectFactory<StatefulListState<T, StatefulList<T>>> state;
  ScrollController? controller;
}

class NavigatorActionArguments<T> {
  T? model;
  Object? arguments;
  Future<bool> Function(T? model)? action;

  NavigatorActionArguments({
    this.model,
    this.arguments,
    this.action,
  });
}

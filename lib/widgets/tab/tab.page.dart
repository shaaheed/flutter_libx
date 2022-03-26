import 'package:flutter/material.dart';
import '/object_factory.dart';
import '/widgets/page/page.mixin.dart';
import '/widgets/page/stateful.page.dart';
import '/enums/display_as.dart';
import '../../models/model.dart';
import '/widgets/list/list.widget.dart';
import 'abstract_tab.view.dart';
import '../widgets.dart';
export 'tab_view.dart';

abstract class TabPage<T, TModel extends Model<TModel>,
        TView extends AbstractTabView<T, TModel>> extends StatefulPage
    with PageMixin {
  final DisplayAs displayAs;
  final ObjectFactory<_TabPageState<T, TModel, TView>> state = ObjectFactory(
    () => _TabPageState<T, TModel, TView>(),
  );

  TabPage({
    Object? arguments,
    this.displayAs = DisplayAs.listView,
    Key? key,
  }) : super(
          arguments: arguments,
          key: key,
        );

  // Widget buildWidget(BuildContext context, Widget? widget) =>
  //     widget ?? const SizedBox();

  String? buildTabTitle(T model);

  Future<List<T>> getTabs(BuildContext context);

  TView createTabView(T model, int index);

  int getInitialIndex(int tabCount) => 0;

  int getCurrentIndex() => state.getCurrent()._currentIndex;

  /// Refresh TabPage with its all TabView.
  @override
  refresh(Object arguments) => state.getCurrent().refresh(arguments);

  void resetTabPageWithAllTabViews() =>
      state.getCurrent().resetTabPageWithAllTabViews();

  TView? getSelectedTabView() => state.getCurrent().getSelectedTabView();

  void onTabChanged(int selectedIndex) {
    var _state = state.getCurrent();
    if (!_state._tabVisited.containsKey(selectedIndex)) {
      _state._tabVisited[selectedIndex] = false;
    }
    if (!_state._tabVisited.containsKey(selectedIndex)) {
      _state._tabVisited[selectedIndex] = true;
      _state._tabViews[selectedIndex].onTabChanged(selectedIndex);
    }
  }

  AppBar getTabPageAppBar(
    BuildContext context,
    TabController tabController,
    List<T> tabs,
  ) {
    return BackAppBar(
      context: context,
      title: getTitle(context),
      actions: getAppBarActions(context),
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(AppBar().preferredSize.height),
        child: TabBar(
          controller: tabController,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.grey[900],
          labelColor: Colors.grey[900],
          tabs: tabs.map((x) {
            return Tab(
              child: Text(buildTabTitle(x)?.toUpperCase() ?? ""),
            );
          }).toList(),
        ),
      ),
    );
  }

  // @override
  // Widget getScaffold(BuildContext context) => null;

  @override
  // ignore: no_logic_in_create_state
  _TabPageState<T, TModel, TView> createState() => state.createNew();
}

class _TabPageState<T, TModel extends Model<TModel>,
        TView extends AbstractTabView<T, TModel>>
    extends State<TabPage<T, TModel, AbstractTabView<T, TModel>>>
    with
        TickerProviderStateMixin<
            TabPage<T, TModel, AbstractTabView<T, TModel>>> {
  late TabController _controller;
  List<T> _tabs = [];
  List<TView> _tabViews = [];
  int _initialIndex = 0;
  int _currentIndex = 0;

  Map<int, bool> _tabVisited = {};
  bool init = false;

  @override
  initState() {
    widget.getTabs(context).then((value) {
      _tabs = value;
      _initialIndex = widget.getInitialIndex(_tabs.length);

      // tab controller
      _controller = TabController(
        initialIndex: _initialIndex,
        length: _tabs.length,
        vsync: this,
      );

      _tabViews = List.generate(
        _tabs.length,
        (index) {
          var view = widget.createTabView(_tabs[index], index);
          return view as TView;
        },
      );

      _controller.addListener(tabListener);

      widget.onTabChanged(_initialIndex);
      setState(() {
        init = true;
      });
    });

    super.initState();
  }

  /// Refresh TabPage with its all TabView.
  void refresh(Object arguments) {}

  void resetTabPageWithAllTabViews() {
    _tabVisited = {};
    for (var view in _tabViews) {
      view.reset();
    }
    widget.onTabChanged(_controller.index);
  }

  TView? getSelectedTabView() {
    if (_controller.index >= 0 && _tabViews.isNotEmpty) {
      return _tabViews[_controller.index];
    }
    return null;
  }

  List<TView> getTabViews() => _tabViews;

  void tabListener() {
    if (!_controller.indexIsChanging) {
      _currentIndex = _controller.index;
      widget.onTabChanged(_currentIndex);
      // ignore: avoid_print
      print("tab change: $_currentIndex");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!init) return const CircularProgress();
    var selectedTab = getSelectedTabView();
    FloatingActionButton? floatingActionButton;
    FloatingActionButtonLocation? floatingActionButtonLocation;
    if (selectedTab is StatefulList<TModel>) {
      floatingActionButton = (selectedTab as StatefulList<TModel>)
          .getFloatingActionButton(context);
      floatingActionButtonLocation = (selectedTab as StatefulList<TModel>)
          .getFloatingActionButtonLocation();
    }

    return widget.buildWidget(
      context,
      AppScaffold(
        appBar: widget.getTabPageAppBar(context, _controller, _tabs),
        body: TabBarView(
          controller: _controller,
          children: _tabViews as List<Widget>,
        ),
        drawer: widget.getDrawer(context),
        bottomNavigationBar: widget.getBottomAppBar(context),
        floatingActionButton: floatingActionButton,
        floatingActionButtonLocation: floatingActionButtonLocation,
      ),
    );
  }

  @override
  void dispose() {
    _controller.removeListener(tabListener);
    _controller.dispose();
    if (_tabViews.isNotEmpty) {
      for (var tabView in _tabViews) {
        tabView.dispose();
      }
    }
    _tabViews = [];
    _tabs = [];
    _tabVisited = {};
    widget.dispose();
    super.dispose();
  }
}

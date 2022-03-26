import 'package:flutter/material.dart';
import '../../models/model.dart';
import '/object_factory.dart';
import 'abstract_tab.view.dart';

abstract class TabView<T, TModel extends Model<TModel>> extends StatefulWidget
    implements AbstractTabView<T, TModel> {
  @override
  final ObjectFactory<TabViewState<T, TModel, TabView<T, TModel>>> state;

  const TabView(
    this.state,
    int index,
    T model, {
    Key? key,
  }) : super(key: key);

  @override
  BuildContext? get context => state.getCurrent().context;

  @override
  void onTabChanged(int selectedIndex) {}

  @override
  void refresh(Object? arguments) => state.getCurrent().refresh();

  @override
  void initState() {}

  @override
  void dispose() => state.dispose();

  @override
  TabViewState<T, TModel, TabView<T, TModel>> createState() =>
      // ignore: no_logic_in_create_state
      state.createNew();
}

class TabViewState<T, TModel extends Model<TModel>,
    TWidget extends TabView<T, TModel>> extends State<TWidget> {
  void refresh() {
    Future.delayed(Duration.zero, () => setState(() {}));
  }

  @override
  void initState() {
    super.initState();
    widget.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.build(context, null);
  }

  @override
  void dispose() {
    widget.dispose();
    super.dispose();
  }
}

import 'package:flutter/cupertino.dart';
import '/enums/display_as.dart';
import '../../models/model.dart';
import '../list/list.bloc.dart';
import '../list/list.widget.dart';
import 'abstract_tab.view.dart';

abstract class ListTabView<T, TModel extends Model<TModel>>
    extends StatefulList<TModel> implements AbstractTabView<T, TModel> {
  @override
  final T model;

  @override
  final int index;

  ListTabView(
    this.index,
    this.model, {
    required ListBloc<TModel> bloc,
    ScrollController? controller,
    DisplayAs displayAs = DisplayAs.listView,
    Object? arguments,
    Key? key,
  }) : super(
          bloc,
          controller: controller,
          callOnLoadOnInit: false,
          displayAs: displayAs,
          arguments: arguments,
          key: key,
        );

  @override
  void onTabChanged(int selectedIndex) => bloc.load(arguments: arguments);

  @override
  void reset() => data.state.getCurrent().reset();
}

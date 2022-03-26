import 'package:flutter/material.dart';
import '/object_factory.dart';
import '../bottom_nav_item.dart';
import '../../enums/display_as.dart';
import '../../models/model.dart';
import '../list/list.bloc.dart';
import '../list/list.widget.dart';
import 'abstract.page.dart';
import '../widgets.dart';
import '../../extensions/extensions.dart';

abstract class ListPage<T extends Model<T>> extends StatefulList<T>
    implements AbstractPage {
  ListPage(
    ListBloc<T> bloc, {
    DisplayAs displayAs = DisplayAs.listView,
    ScrollController? controller,
    ObjectFactory<StatefulListState<T, StatefulList<T>>>? state,
    Object? arguments,
    Key? key,
  }) : super(
          bloc,
          controller: controller,
          state: state,
          displayAs: displayAs,
          arguments: arguments,
          key: key,
        );

  @override
  Widget buildWidget(BuildContext context, Widget? widget) {
    return getScaffold(context);
  }

  @override
  Widget build(BuildContext context, Widget? widget) =>
      buildWidget(context, widget);

  @override
  Widget getScaffold(BuildContext context) {
    return AppScaffold(
      appBar: getAppBar(context),
      body: super.build(context, null),
      drawer: getDrawer(context),
      floatingActionButton: getFloatingActionButton(context),
      floatingActionButtonLocation: getFloatingActionButtonLocation(),
    );
  }

  @override
  AppBar getAppBar(BuildContext context) {
    return BackAppBar(
      context: context,
      title: getTitle(context).i18n(context),
    );
  }

  @override
  Widget? getDrawer(BuildContext context) => null;

  @override
  List<Widget> getAppBarActions(BuildContext context) => [];

  @override
  List<BottomNavItem> getBottomNavItems(BuildContext context) => [];

  @override
  Widget? getBottomAppBar(BuildContext context) => null;
}

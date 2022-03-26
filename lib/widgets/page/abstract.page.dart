import 'package:flutter/material.dart';
import '../bottom_nav_item.dart';

abstract class AbstractPage {
  Object? get arguments;

  Widget buildWidget(BuildContext context, Widget? widget);

  String getTitle(BuildContext context);

  void refresh(Object arguments);

  Widget getScaffold(BuildContext context);

  Widget? getFloatingActionButton(BuildContext context);

  FloatingActionButtonLocation? getFloatingActionButtonLocation();

  AppBar getAppBar(BuildContext context);

  List<Widget> getAppBarActions(BuildContext context);

  Widget? getDrawer(BuildContext context);

  List<BottomNavItem> getBottomNavItems(BuildContext context);

  Widget? getBottomAppBar(BuildContext context) => null;

  void dispose() {}
}

import 'package:flutter/material.dart';
import '../bottom_nav_item.dart';
import '../../extensions/extensions.dart';
import '../back_appbar.dart';
import '../../const.dart';
import 'abstract.page.dart';

mixin PageMixin on AbstractPage {
  @override
  AppBar? getAppBar(BuildContext context) {
    return BackAppBar(
      context: context,
      title: getTitle(context).i18n(context),
    );
  }

  @override
  Widget? getDrawer(context) => null;

  @override
  void refresh({Object? arguments}) {}

  @override
  List<Widget> getAppBarActions(BuildContext context) => [];

  @override
  List<BottomNavItem> getBottomNavItems(BuildContext context) => [];

  @override
  Widget? getBottomAppBar(BuildContext context) => null;

  @override
  FloatingActionButton? getFloatingActionButton(BuildContext context) => null;

  @override
  FloatingActionButtonLocation? getFloatingActionButtonLocation() =>
      FloatingActionButtonLocation.centerFloat;
  
  @override
  EdgeInsetsGeometry? getPagePadding() => Const.appPagePadding;

  @override
  void dispose() {}
}

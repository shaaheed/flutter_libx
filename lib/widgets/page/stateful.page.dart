import 'package:flutter/material.dart';
import 'package:libx/widgets/widgets.dart';
import '../../extensions/string.extension.dart';
import '../../const.dart';

abstract class StatefulPage extends StatefulWidget implements AbstractPage {
  @override
  final Object? arguments;
  final Color? backgroundColor;
  final Color? appBarBackgroundColor;

  const StatefulPage({
    this.backgroundColor,
    this.appBarBackgroundColor,
    this.arguments,
    Key? key,
  }) : super(key: key);

  @override
  Widget getScaffold(BuildContext context) {
    return AppScaffold(
      backgroundColor: backgroundColor,
      appBar: getAppBar(context),
      body: buildWidget(context, null),
      drawer: getDrawer(context),
      floatingActionButton: getFloatingActionButton(context),
      floatingActionButtonLocation: getFloatingActionButtonLocation(),
    );
  }

  @override
  AppBar? getAppBar(BuildContext context) {
    return BackAppBar(
      backgroundColor: appBarBackgroundColor,
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

  @override
  EdgeInsetsGeometry? getPagePadding() => Const.appPagePadding;
}

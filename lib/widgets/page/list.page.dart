import 'package:flutter/material.dart';
import '/object_factory.dart';
import '../../enums/display_as.dart';
import '../../models/model.dart';
import '../widgets.dart';
import '../../extensions/string.extension.dart';
import '../../services/repository.service.dart';

abstract class ListPage<T extends Model<T>> extends StatefulList<T>
    implements StatefulPage {
  @override
  final Color? backgroundColor;
  @override
  final Color? appBarBackgroundColor;

  ListPage({
    ListBloc<T>? bloc,
    RepositoryService<T>? repository,
    DisplayAs displayAs = DisplayAs.listView,
    ScrollController? controller,
    ObjectFactory<StatefulListState<T, StatefulList<T>>>? state,
    Object? arguments,
    this.backgroundColor,
    this.appBarBackgroundColor,
    Key? key,
  }) : super(
          bloc: bloc,
          repository: repository,
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
      backgroundColor: backgroundColor,
      appBar: getAppBar(context),
      body: super.build(context, null),
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
}

import 'package:flutter/material.dart';
import '/widgets/back_appbar.dart';
import '../../widgets/app_scaffold.dart';
import '../../models/model.dart';
import 'page.mixin.dart';
import 'stateless.page.dart';

abstract class ViewPage<T extends Model<T>> extends StatelessPage
    with PageMixin {
  final EdgeInsets padding;
  final Color? backgroundColor;
  final Color? appBarBackgroundColor;

  const ViewPage({
    this.padding = const EdgeInsets.only(left: 10, right: 20.0),
    this.backgroundColor,
    this.appBarBackgroundColor,
    Object? arguments,
    Key? key,
  }) : super(
          arguments: arguments,
          key: key,
        );

  T? get model;

  @override
  AppBar getAppBar(BuildContext context) {
    return BackAppBar(
      context: context,
      title: getTitle(context),
      backgroundColor: appBarBackgroundColor,
    );
  }

  @override
  Widget getScaffold(BuildContext context) {
    return AppScaffold(
      appBar: getAppBar(context),
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          // if (isLoading) CircularProgress(),
          SingleChildScrollView(
            child: Padding(
              padding: padding,
              child: buildWidget(context, null),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) => getScaffold(context);
}

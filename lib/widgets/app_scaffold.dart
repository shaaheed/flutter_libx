import 'package:flutter/material.dart';
import '/services/app.service.dart';
import 'widgets.dart';

class AppScaffold extends StatelessWidget {
  final PreferredSizeWidget? appBar;
  final String? appBarTitle;
  final Widget? drawer;
  final Widget body;
  final Color? backgroundColor;
  final Widget? bottomNavigationBar;
  final FloatingActionButton? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;

  const AppScaffold({
    required this.body,
    this.appBarTitle,
    this.appBar,
    this.drawer,
    this.backgroundColor,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppService.setContext(context);
    return Scaffold(
      backgroundColor: backgroundColor ?? Colors.white, //.grey.shade50,
      appBar: appBar ?? AppAppBar(title: appBarTitle),
      drawer: drawer,
      body: body,
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
    );
  }
}

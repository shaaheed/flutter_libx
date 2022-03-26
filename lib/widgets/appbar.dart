import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppAppBar extends AppBar {
  AppAppBar({
    String? title,
    Widget? titleWidget,
    double elevation = 0.0,
    Widget? leading,
    PreferredSizeWidget? bottom,
    List<Widget>? actions,
    bool centerTitle = true,
    SystemUiOverlayStyle? systemOverlayStyle,
    Color? backgroundColor,
    Key? key,
  }) : super(
          elevation: elevation,
          iconTheme: IconThemeData(color: Colors.grey[800]),
          backgroundColor: backgroundColor ?? Colors.transparent,
          title: titleWidget ??
              (title != null
                  ? Text(
                      title,
                      style: TextStyle(
                        color: Colors.grey.shade900,
                        fontWeight: FontWeight.w400,
                      ),
                    )
                  : null),
          centerTitle: centerTitle,
          systemOverlayStyle: systemOverlayStyle ??
              const SystemUiOverlayStyle(
                statusBarIconBrightness:
                    Brightness.dark, // status bar icon color
                systemNavigationBarIconBrightness:
                    Brightness.dark, // color of navigation controls
                statusBarBrightness: Brightness.light,
                statusBarColor: Colors.transparent,
              ),
          leading: leading,
          bottom: bottom,
          actions: actions,
          key: key,
        );
}

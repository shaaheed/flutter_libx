import 'package:flutter/material.dart';
import 'appbar.dart';

class BackAppBar extends AppAppBar {
  BackAppBar({
    BuildContext? context,
    String? title,
    PreferredSizeWidget? bottom,
    List<Widget>? actions,
    bool noBack = false,
    Color? backgroundColor,
    double elevation = 0.0,
    Key? key,
  }) : super(
          title: title,
          leading: noBack
              ? null
              : IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios_rounded,
                    size: 20,
                  ),
                  onPressed: () {
                    if (context != null) {
                      Navigator.pop(
                        context,
                        'Cancelled',
                      );
                    }
                  },
                ),
          bottom: bottom,
          actions: actions,
          backgroundColor: backgroundColor,
          elevation: elevation,
          key: key,
        );
}

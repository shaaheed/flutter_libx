import 'package:flutter/material.dart';
import 'page.mixin.dart';
import 'stateful.page.dart';

abstract class Page extends StatefulPage with PageMixin {
  Page({
    Object? arguments,
    Key? key,
  }) : super(
          arguments: arguments,
          key: key,
        );
}

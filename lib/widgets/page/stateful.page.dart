import 'package:flutter/material.dart';
import './abstract.page.dart';

abstract class StatefulPage extends StatefulWidget implements AbstractPage {
  @override
  final Object? arguments;

  const StatefulPage({
    this.arguments,
    Key? key,
  }) : super(key: key);
}

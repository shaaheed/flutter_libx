import 'package:flutter/material.dart';
import './abstract.page.dart';

abstract class StatelessPage extends StatelessWidget implements AbstractPage {
  @override
  final Object? arguments;

  const StatelessPage({
    this.arguments,
    Key? key,
  }) : super(key: key);
}

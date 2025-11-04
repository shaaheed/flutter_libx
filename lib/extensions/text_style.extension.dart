import 'package:flutter/material.dart';

extension TextStyleExtension on TextStyle {
  static TextStyle errorStyle(BuildContext context) {
    return TextStyle(color: Theme.of(context).colorScheme.error);
  }
}

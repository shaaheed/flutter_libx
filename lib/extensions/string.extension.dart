import '../services/localization.service.dart';
import 'package:flutter/material.dart';

extension StringExtension on String {
  String i18n(BuildContext? context) {
    if (context == null) return this;
    return LocalizationService.of(context)!.translate(this);
  }
}

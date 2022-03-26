// Copyright 2022 Sahidul Islam. All rights reserved.
// Author: https://github.com/shaaheed

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LocalizationService {
  static List<Locale> _supportedLocales = [];
  final Locale locale;
  final String path = "assets/i18n";

  LocalizationService(this.locale);

  // Helper method to keep the code in the widgets concise
  // Localizations are accessed using an InheritedWidget "of" syntax
  static LocalizationService? of(BuildContext context) {
    return Localizations.of<LocalizationService>(context, LocalizationService);
  }

  static void setSupportedLocales(List<Locale> supportedLocales) {
    _supportedLocales = supportedLocales;
  }

  // Static member to have a simple access to the delegate from the MaterialApp
  static const LocalizationsDelegate<LocalizationService> delegate =
      _AppLocalizationsDelegate();

  Map<String, String> _localizedStrings = {};

  Future<bool> load() async {
    // Load the language JSON file from the "lang" folder
    String jsonString =
        await rootBundle.loadString('$path/${locale.languageCode}.json');
    Map<String, dynamic> jsonMap = json.decode(jsonString);

    _localizedStrings = jsonMap.map((key, value) {
      return MapEntry(key, value.toString());
    });

    return true;
  }

  // This method will be called from every widget which needs a localized text
  String translate(String key) {
    return _localizedStrings[key] ?? key;
  }
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<LocalizationService> {
  // This delegate instance will never change (it doesn't even have fields!)
  // It can provide a constant constructor.
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    // Include all of your supported language codes here
    return LocalizationService._supportedLocales.contains(locale);
  }

  @override
  Future<LocalizationService> load(Locale locale) async {
    // AppLocalizations class is where the JSON loading actually runs
    LocalizationService localizations = LocalizationService(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

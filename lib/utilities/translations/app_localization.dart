import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'welcome': 'Welcome',
      'to_the_doctor_app': 'To the Doctor App',
    },
    'fr': {
      'welcome': 'Bienvenue',
      'to_the_doctor_app': 'À l\'application médicale',
    },
    'lg': {
      'welcome': 'Tukusanyukidde',
      'to_the_doctor_app': 'Ku Dokita App',
    },
  };

  String translate(String key) {
    return _localizedValues[locale.languageCode]![key] ?? key;
  }
}

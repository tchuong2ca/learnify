import 'package:flutter/material.dart';

import 'languages.dart';
import 'en.dart';
import 'vi.dart';

class AppLocalizationsDelegate extends LocalizationsDelegate<Languages>{
  @override
  bool isSupported(Locale locale) => ['en', 'vi'].contains(locale.languageCode);

  @override
  Future<Languages> load(Locale locale) {
    // TODO: implement load
    return _load(locale);
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<Languages> old) {
    // TODO: implement shouldReload
    return false;
  }

  static Future<Languages> _load(Locale locale) async{
    switch(locale.languageCode){
      case 'en':
        return LanguageEn();
      case 'vi':
        return LanguagesVn();
      default:
        return LanguagesVn();
    }
  }
}
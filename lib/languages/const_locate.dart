import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../application.dart';

const String prefSelectedLanguageCode = "SelectedLanguageCode";

Future<Locale> setLocale(String languageCode) async{
  SharedPreferences preferences = await SharedPreferences.getInstance();
  await preferences.setString(prefSelectedLanguageCode, languageCode);
  return _locale(languageCode);
}

Future<Locale> getLocale() async{
  SharedPreferences preferences = await SharedPreferences.getInstance();
  String? languageCode = preferences.getString(prefSelectedLanguageCode)!=null?'en': 'vi';
  return _locale(languageCode);
}
Locale _locale(String languageCode){
  return languageCode != null && languageCode.isNotEmpty
      ? Locale(languageCode, '')
      : Locale('en', '');
}

void changeLanguage(BuildContext context, String selectedLanguageCode) async{
  var _locale = await setLocale(selectedLanguageCode);
  Application.setLocale(context, _locale);
}
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';


class LocalizationManager {
  static Map<String, String> _localizedStrings = {};

  // Load the selected language JSON file
  static Future<void> load(String languageCode) async {
    final String jsonString = await rootBundle.loadString('assets/lang/strings_$languageCode.json');
    final Map<String, dynamic> jsonMap = json.decode(jsonString);

    // Ensure underscores are replaced with spaces if needed
    _localizedStrings = jsonMap.map((key, value) => MapEntry(key, value.toString().replaceAll('_', ' ')));
  }

  // Get a string by key
  static String getString(String key) {
    return _localizedStrings[key] ?? key;
  }

  // Save the selected language
  static Future<void> saveLanguage(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_language', languageCode);
  }

  // Get the saved language
  static Future<String> getSavedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('selected_language') ?? 'en'; // Default to English
  }
}

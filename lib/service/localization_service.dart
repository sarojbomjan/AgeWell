import 'dart:convert';
import 'package:flutter/services.dart';

class LocalizationService {
  static Map<String, String> _localizedStrings = {};

  // Load translations from the corresponding JSON file based on language
  static Future<void> loadLanguage(String langCode) async {
    try {
      String jsonString =
          await rootBundle.loadString('assets/lang/$langCode.json');
      Map<String, dynamic> jsonMap = json.decode(jsonString);

      _localizedStrings = jsonMap.map((key, value) {
        return MapEntry(key, value.toString());
      });
    } catch (e) {
      print("Error loading language file for $langCode: $e");
      // Fallback to English if there is an issue
      await loadLanguage('en');
    }
  }

  // Get translation for a key
  static String translate(String key) {
    return _localizedStrings[key] ??
        key; // Return key if translation is not found
  }
}

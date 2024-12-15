import 'package:elderly_care/pages/community/community.dart';
import 'package:elderly_care/pages/health/health.dart';
import 'package:elderly_care/pages/home/home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

import 'localization_service.dart';

class VoiceCommandService {
  final stt.SpeechToText _speech = stt.SpeechToText();
  String _languageCode = 'en'; // Default to English

  // Request permission for microphone
  Future<void> requestPermission() async {
    var status = await Permission.microphone.request();
    if (!status.isGranted) {
      print("Microphone permission denied.");
    }
  }

  // Start listening for commands
  Future<void> startListening(BuildContext context) async {
    await requestPermission();

    bool available = await _speech.initialize(
      onStatus: (status) => print('Speech status: $status'),
      onError: (error) => print('Speech error: $error'),
    );

    if (available) {
      // Start listening with the localeId for the selected language
      _speech.listen(
        localeId: _languageCode,
        onResult: (result) {
          String command = result.recognizedWords.toLowerCase();
          _processCommand(context, command);
        },
      );
    }
  }

  // Stop listening for commands
  void stopListening() {
    if (_speech.isListening) {
      _speech.stop();
    }
  }

  void _processCommand(BuildContext context, String command) {
    final homeScreenState = HomeScreen.homeKey.currentState;
    if (homeScreenState != null && homeScreenState.mounted) {
      if (command.contains('heart rate')) {
        homeScreenState.onNavTap(1); // Navigate to Health page (index 1)
      } else if (command.contains('emergency')) {
        homeScreenState.onSOSButtonPressed();
      } else if (command.contains('chat')) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Community()),
        );
      } else {
        print('Command not recognized: $command');
      }
    } else {
      print("HomeScreen state not found or widget not mounted");
    }
  }

  // Check if a language is supported by the SpeechToText package
  Future<bool> isLanguageSupported(String langCode) async {
    List<stt.LocaleName> locales = await _speech.locales();
    return locales.any((locale) => locale.localeId == langCode);
  }

  // Change language for speech recognition and load the corresponding translations
  Future<void> changeLanguage(String langCode) async {
    bool isSupported = await isLanguageSupported(langCode);

    if (isSupported) {
      _languageCode = langCode;
      print('Language changed to: $langCode');
    } else {
      _languageCode = 'en'; // Fallback to English if language is not supported
      print('Language not supported, switching to English.');
    }

    // Load the selected language for translations
    await LocalizationService.loadLanguage(_languageCode);
  }

  Future<void> checkSupportedLanguages() async {
    List<stt.LocaleName> locales = await _speech.locales();
    if (locales.isEmpty) {
      print(
          'No locales available. Ensure the SpeechToText package is initialized correctly.');
    } else {
      for (var locale in locales) {
        print('Supported Locale: ${locale.localeId}');
      }
    }
  }
}

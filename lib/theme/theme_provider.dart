import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:elderly_care/theme/theme.dart';

class ThemeController extends GetxController {
  Rx<ThemeData> _themeData = AppTheme.lightTheme.obs;

  ThemeData get themeData => _themeData.value;

  void toggleTheme() {
    print(
        'Current theme: ${_themeData.value == AppTheme.lightTheme ? 'Light' : 'Dark'}');
    _themeData.value = (_themeData.value == AppTheme.lightTheme)
        ? AppTheme.darkTheme
        : AppTheme.lightTheme;
  }
}

import "package:elderly_care/theme/widget_theme/elevated_button_theme.dart";
import "package:flutter/material.dart";
import "widget_theme/text_theme.dart";
import "widget_theme/outlined_button_theme.dart";

class AppTheme {
  AppTheme._();

  static ThemeData lightTheme = ThemeData(
      brightness: Brightness.light,
      textTheme: CustomTextTheme.lightTextTheme,
      outlinedButtonTheme: AOutlinedButtonTheme.lightOutlinedButtonTheme,
      elevatedButtonTheme: AElevatedButtonTheme.lightElevatedButtonTheme);

  static ThemeData darkTheme = ThemeData(
      brightness: Brightness.dark,
      textTheme: CustomTextTheme.darkTextTheme,
      outlinedButtonTheme: AOutlinedButtonTheme.darkOutlinedButtonTheme,
      elevatedButtonTheme: AElevatedButtonTheme.darkElevatedButtonTheme);
}

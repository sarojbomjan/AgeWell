import "package:elderly_care/constants/color.dart";
import "package:flutter/material.dart";

class AElevatedButtonTheme {
  AElevatedButtonTheme._();

  // light theme
  static final lightElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      foregroundColor: whiteColor,
      backgroundColor: secondaryColor,
      side: BorderSide(color: secondaryColor),
      padding: EdgeInsets.symmetric(vertical: 20),
    ),
  );

  // dark theme
  static final darkElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      foregroundColor: darkColor, // Text in contrast to white background
      backgroundColor: whiteColor, // White for clear visibility
      side: BorderSide(color: secondaryColor), // Optional border
      padding: EdgeInsets.symmetric(vertical: 20),
    ),
  );
}

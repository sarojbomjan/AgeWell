import "package:elderly_care/constants/color.dart";
import "package:flutter/material.dart";

class AOutlinedButtonTheme {
  AOutlinedButtonTheme._();

  // light theme
  static final lightOutlinedButtonTheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      foregroundColor: secondaryColor,
      side: BorderSide(color: secondaryColor),
      padding: EdgeInsets.symmetric(vertical: 20),
    ),
  );

  // dark theme
  static final darkOutlinedButtonTheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      foregroundColor: whiteColor,
      side: BorderSide(color: whiteColor),
      padding: EdgeInsets.symmetric(vertical: 20),
    ),
  );
}

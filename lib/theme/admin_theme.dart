import 'package:flutter/material.dart';

class AdminTheme {
  static const Color primaryColor = Color(0xFF6750A4);
  static const Color secondaryColor = Color(0xFFD0BCFF);
  static const Color backgroundColor = Color(0xFFF6F5F7);
  static const Color cardColor = Colors.white;
  static const Color textColor = Color(0xFF1C1B1F);
  static const Color subTextColor = Color(0xFF49454F);

  static ThemeData get theme => ThemeData(
        primaryColor: primaryColor,
        scaffoldBackgroundColor: backgroundColor,
        cardColor: cardColor,
        textTheme: const TextTheme(
          headlineLarge:
              TextStyle(color: textColor, fontWeight: FontWeight.bold),
          headlineMedium:
              TextStyle(color: textColor, fontWeight: FontWeight.bold),
          headlineSmall:
              TextStyle(color: textColor, fontWeight: FontWeight.bold),
          bodyLarge: TextStyle(color: subTextColor),
          bodyMedium: TextStyle(color: textColor),
          bodySmall: TextStyle(color: subTextColor),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: primaryColor,
          elevation: 0,
        ),
      );
}

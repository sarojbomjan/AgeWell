import "package:elderly_care/constants/color.dart";
import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";

class CustomTextTheme {
  CustomTextTheme._();

  static TextTheme lightTextTheme = TextTheme(
    headlineMedium: GoogleFonts.montserrat(
      color: darkColor, // Dark color for light mode
    ),
    headlineLarge: GoogleFonts.montserrat(
      color: darkColor, // Dark color for light mode
    ),
    headlineSmall: GoogleFonts.montserrat(
      color: darkColor, // Dark color for light mode
    ),
    bodyMedium: GoogleFonts.poppins(color: darkColor, fontSize: 20),
  );

  static TextTheme darkTextTheme = TextTheme(
    headlineMedium: GoogleFonts.montserrat(
      color: whiteColor, // Lighter color for dark mode
    ),
    headlineLarge: GoogleFonts.montserrat(
      color: whiteColor, // Lighter color for dark mode
    ),
    headlineSmall: GoogleFonts.montserrat(
      color: whiteColor, // Lighter color for dark mode
    ),
    bodyMedium: GoogleFonts.poppins(color: whiteColor, fontSize: 20),
    bodySmall: GoogleFonts.montserrat(
      color: whiteColor, // Lighter color for dark mode
    ),
  );
}

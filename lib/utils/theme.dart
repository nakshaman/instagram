import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:insta/utils/colors.dart';

class AppTheme {
  static final darkTheme = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: mobileBackgroundColor,
    appBarTheme: const AppBarThemeData(
      titleTextStyle: TextStyle(
        color: primaryColor,
      ),
      backgroundColor: mobileBackgroundColor,
    ),
    textTheme: GoogleFonts.ubuntuCondensedTextTheme(ThemeData.dark().textTheme)
        .copyWith(
          titleSmall: GoogleFonts.ubuntuCondensed(fontWeight: FontWeight.bold),
          titleMedium: GoogleFonts.ubuntuCondensed(fontWeight: FontWeight.bold),
          titleLarge: GoogleFonts.ubuntuCondensed(fontWeight: FontWeight.bold),
        )
        .apply(
          bodyColor: primaryColor,
          displayColor: primaryColor,
        ),
  );
}

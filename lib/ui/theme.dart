import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const red = Color(0xFFF54135);
const green = Color(0xFF76EE59);
const black = Color(0xFF000000);

const background = Color(0xFF352F44);
const onBackground = Color(0xFFFAF0E6);
const surface = Color(0xFF5C5470);

const gray1 = Color(0xFFB9B4C7); // Used for switches

const colorScheme = ColorScheme(
  primary: onBackground,
  onPrimary: background,
  secondary: gray1,
  onSecondary: green,
  surface: surface,
  onSurface: onBackground,
  error: red,
  onError: red,
  brightness: Brightness.dark,
);

ThemeData getThemeData() {
  return ThemeData.from(
    colorScheme: colorScheme,
    textTheme: GoogleFonts.baloo2TextTheme(
      ThemeData.dark().textTheme,
    ).apply(
      bodyColor: onBackground,
      displayColor: onBackground,
    ),
  );
}

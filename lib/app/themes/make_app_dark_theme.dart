import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData makeAppDarkTheme() {
  final _primaryColor = Color.fromRGBO(35, 45, 72, 1);
  final _primaryColorDark = Color.fromRGBO(96, 0, 39, 1);
  final _primaryColorLight = Color.fromRGBO(188, 71, 123, 1);
  final _backgroundColor = Color.fromRGBO(36, 37, 38, 1);

  final _accentColor = Colors.blueGrey[700];
  return ThemeData(
    primaryColor: _primaryColor,
    primaryColorDark: _primaryColorDark,
    primaryColorLight: _primaryColorLight,
    brightness: Brightness.dark,
    accentColor: _accentColor,
    backgroundColor: _backgroundColor,
    textTheme: TextTheme(
      headline1: GoogleFonts.itim(
        fontSize: 28,
        fontWeight: FontWeight.w700,
      ),
      headline2: GoogleFonts.itim(
        fontSize: 16,
        fontWeight: FontWeight.w700,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: _primaryColorLight,
        ),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: _primaryColor,
        ),
      ),
      alignLabelWithHint: true,
    ),
    buttonTheme: ButtonThemeData(
      colorScheme: ColorScheme.light(
        primary: _primaryColor,
      ),
      buttonColor: _primaryColor,
      splashColor: _primaryColorLight,
      padding: EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 20,
      ),
      textTheme: ButtonTextTheme.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    ),
  );
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData makeAppLightTheme() {
  final _primaryColor = Color.fromRGBO(35, 45, 72, 1);
  final _primaryColorDark = Color.fromRGBO(96, 0, 39, 1);
  final _primaryColorLight = Color.fromRGBO(188, 71, 123, 1);
  final _accentColor = Colors.white;
  return ThemeData(
    primaryColor: _primaryColor,
    primaryColorDark: _primaryColorDark,
    primaryColorLight: _primaryColorLight,
    accentColor: _accentColor,
    backgroundColor: Colors.white,
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

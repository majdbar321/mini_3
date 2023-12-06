import 'package:flutter/material.dart';

final ThemeData appTheme = ThemeData(
  // Brightness (Light/Dark Theme)
  brightness: Brightness.light,

  // Primary swatch and accent color
  primarySwatch: Colors.blue,
  hintColor: Colors.blueAccent,

  // Font family
  fontFamily: 'Roboto',

  // Text theme
  textTheme: TextTheme(
    headline1: TextStyle(
        fontSize: 72.0, fontWeight: FontWeight.bold, color: Colors.blue),
    headline2: TextStyle(fontSize: 60.0, fontWeight: FontWeight.w500),
    headline3: TextStyle(fontSize: 48.0, fontWeight: FontWeight.w500),
    headline4: TextStyle(fontSize: 34.0, fontWeight: FontWeight.w400),
    headline5: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w400),
    headline6: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500),
    subtitle1: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w400),
    subtitle2: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500),
    bodyText1: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w400),
    bodyText2: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400),
    button: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500),
    caption: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w400),
    overline: TextStyle(fontSize: 10.0, fontWeight: FontWeight.w400),
  ),

  // App bar theme
  appBarTheme: AppBarTheme(
    color: Colors.blue,
    elevation: 4.0,
    shadowColor: Colors.blueAccent.shade200,
    iconTheme: IconThemeData(color: Colors.white),
    titleTextStyle: TextStyle(
        color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),
    toolbarTextStyle: TextStyle(color: Colors.white),
  ),

  // Button theme
  buttonTheme: ButtonThemeData(
    buttonColor: Colors.blue,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    textTheme: ButtonTextTheme.primary,
  ),

  // Elevated button theme
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      primary: Colors.blue,
      onPrimary: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
  ),

  // Input decoration theme (for TextFormFields)
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: Colors.blueAccent),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: Colors.blue, width: 2),
    ),
    labelStyle: TextStyle(color: Colors.blue),
    hintStyle: TextStyle(color: Colors.blueAccent),
  ),

  // Card theme
  cardTheme: CardTheme(
    color: Colors.white,
    elevation: 2,
    shadowColor: Colors.blueAccent.shade100,
    margin: EdgeInsets.all(10),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
  ),

  // Snackbar theme
  snackBarTheme: SnackBarThemeData(
    backgroundColor: Colors.blue,
    contentTextStyle: TextStyle(color: Colors.white),
    actionTextColor: Colors.white,
  ),

  // Other properties...
);

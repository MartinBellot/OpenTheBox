import 'package:flutter/material.dart';

class ColorOpenTheBox {
  static const Color main = Colors.blue;
  static const Color secondary = Colors.blueAccent;
  static const Color background = Colors.white;
  static const Color text = Colors.black;
  static const Color textSecondary = Colors.grey;
  static const Color textError = Colors.red;
  static const Color textSuccess = Colors.green;
  static const Color textWarning = Colors.orange;
  static const Color textInfo = Colors.blue;
}

class ThemeOpenTheBox {
  static final ThemeData lightTheme = ThemeData(
    colorScheme: ColorScheme.fromSwatch().copyWith(
      primary: ColorOpenTheBox.main,
      secondary: ColorOpenTheBox.secondary,
    ),
  );
}

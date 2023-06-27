import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ThemeCostum {
  final Color primaryColor = Colors.green;
  final Color highlightColor = Colors.green.shade100;
  ThemeData get ligthTheme => ThemeData(
      shadowColor: Colors.white24,
      appBarTheme:
          const AppBarTheme(systemOverlayStyle: SystemUiOverlayStyle.dark),
      scaffoldBackgroundColor: Colors.grey.shade200,
      primaryColor: primaryColor,
      highlightColor: highlightColor,
      floatingActionButtonTheme:
          FloatingActionButtonThemeData(backgroundColor: primaryColor));

  ThemeData get darkTheme => ThemeData(
      //TODO: fix theme dark
      shadowColor: Colors.black26,
      appBarTheme:
          const AppBarTheme(systemOverlayStyle: SystemUiOverlayStyle.dark),
      scaffoldBackgroundColor: Colors.black38,
      primaryColor: primaryColor,
      highlightColor: highlightColor,
      floatingActionButtonTheme:
          FloatingActionButtonThemeData(backgroundColor: primaryColor));
}

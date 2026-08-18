import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

ThemeData lightMode = ThemeData(
    colorScheme: ColorScheme.light(
        surface: Colors.grey.shade300,
        primary: Colors.grey.shade500,
        secondary: Colors.grey.shade200,
        tertiary: Colors.grey.shade900),
    appBarTheme: const AppBarTheme(
      // No statusBarColor/systemNavigationBarColor: setting them triggers
      // Window.setStatusBarColor/setNavigationBarColor, deprecated on Android 15+.
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    ));

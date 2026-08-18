import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

ThemeData darkMode = ThemeData(
    colorScheme: ColorScheme.dark(
        surface: const Color.fromARGB(255, 20, 20, 20),
        primary: const Color.fromARGB(255, 105, 105, 105),
        secondary: const Color.fromARGB(255, 30, 30, 30),
        tertiary: const Color.fromARGB(255, 47, 47, 47),
        inversePrimary: Colors.grey.shade300),
    appBarTheme: const AppBarTheme(
      // No statusBarColor/systemNavigationBarColor: setting them triggers
      // Window.setStatusBarColor/setNavigationBarColor, deprecated on Android 15+.
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    ));

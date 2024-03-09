import 'package:flutter/material.dart';

final ThemeData myTheme = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.brown,
    scaffoldBackgroundColor: const Color(0xFF6C5A44),
    
    colorScheme: const ColorScheme(
        brightness: Brightness.dark,
        primary: Color.fromARGB(255, 221, 209, 190),
        onPrimary: Color(0xFF212121),
        secondary: Color(0xFF24211C),
        onSecondary: Color(0xFF9A8F7E),
        error: Colors.red,
        onError: Colors.white,
        background: Color(0xFF7B7060),
        onBackground: Colors.white,
        surface: Color.fromARGB(255, 25, 24, 22),
        onSurface: Colors.white),
    drawerTheme: const DrawerThemeData(
      backgroundColor: Color(0xFF24211C),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color(0x922D2722),
      selectedItemColor: Color(0xFFE6D7C5),
      unselectedItemColor: Color(0xFFAEA9A3),
      // unselectedIconTheme: IconThemeData(size: 25.0, color: Color(0xFFAEA9A3)),
    ),
    textTheme: const TextTheme(titleLarge: TextStyle(fontSize: 19)),
    );

import 'package:flutter/material.dart';

final ThemeData myTheme = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.brown,
    scaffoldBackgroundColor: const Color(0xFF7B7060),
    colorScheme: const ColorScheme(
        brightness: Brightness.dark,
        primary: Color(0xFF493922),
        onPrimary: Color(0xFF212121),
        secondary: Color(0xFF24211C),
        onSecondary: Color(0xFF9A8F7E),
        error: Colors.red,
        onError: Colors.white,
        background: Color(0xFF7B7060),
        onBackground: Colors.white,
        surface: Color(0xFF24211C),
        onSurface: Colors.white),
    drawerTheme: const DrawerThemeData(
      backgroundColor: Color(0xFF24211C),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData( 
      backgroundColor: Color.fromARGB(147, 45, 39, 34),
      selectedItemColor: Color.fromARGB(255, 230, 215, 197),
      unselectedItemColor: Color(0xFFAEA9A3),
      unselectedIconTheme: IconThemeData(size: 25.0, color: Color(0xFFAEA9A3)),
    )
    );

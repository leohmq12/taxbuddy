import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: const Color(0xFF004B9C),
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF004B9C),
    foregroundColor: Colors.white,
    elevation: 0,
  ),
  // Bottom Navigation Bar Theme (Light Mode)
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Colors.white,
    selectedItemColor: Color(0xFF004B9C), // Selected tab color
    unselectedItemColor: Colors.grey, // Unselected tab color
    selectedIconTheme: IconThemeData(color: Color(0xFF004B9C)),
    unselectedIconTheme: IconThemeData(color: Colors.grey),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF004B9C),
      foregroundColor: Colors.white,
    ),
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Color(0xFF004B9C),
    foregroundColor: Colors.white,
  ),
  colorScheme: ColorScheme.light(
    primary: const Color(0xFF004B9C),
    onPrimary: Colors.white,
    secondary: const Color(0xFF007BFF),
    onSecondary: Colors.white,
    background: Colors.white,
    onBackground: Colors.black,
    surface: const Color(0xFFF5F5F5),
    onSurface: Colors.black,
    error: Colors.red,
    onError: Colors.white,
  ),
  textTheme: GoogleFonts.urbanistTextTheme(ThemeData.light().textTheme),
);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: const Color(0xFF003366),
  scaffoldBackgroundColor: const Color(0xFF121212),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF003366),
    foregroundColor: Colors.white,
    elevation: 0,
  ),
  // Bottom Navigation Bar Theme (Dark Mode)
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Color(0xFF1E1E1E),
    selectedItemColor: Color(0xFF007BFF),
    unselectedItemColor: Colors.grey,
    selectedIconTheme: IconThemeData(color: Color(0xFF007BFF)),
    unselectedIconTheme: IconThemeData(color: Colors.grey),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF003366),
      foregroundColor: Colors.white,
    ),
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Color(0xFF003366),
    foregroundColor: Colors.white,
  ),
  colorScheme: ColorScheme.dark(
    primary: const Color(0xFF003366),
    onPrimary: Colors.white,
    secondary: const Color(0xFF007BFF),
    onSecondary: Colors.white,
    background: const Color(0xFF121212),
    onBackground: Colors.white,
    surface: const Color(0xFF1E1E1E),
    onSurface: Colors.white,
    error: Colors.red,
    onError: Colors.white,
  ),
  textTheme: GoogleFonts.urbanistTextTheme(ThemeData.dark().textTheme),
);
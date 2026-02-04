import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get rgbTheme {
    return ThemeData(
      primaryColor: const Color.fromRGBO(0, 123, 255, 1.0), // Custom RGB primary (blue)
      colorScheme: ColorScheme.fromSwatch().copyWith(
        primary: const Color.fromRGBO(0, 123, 255, 1.0),
        secondary: const Color.fromRGBO(255, 193, 7, 1.0), // Custom RGB accent (yellow)
        surface: const Color.fromRGBO(255, 255, 255, 1.0), // White for cards/surfaces
        background: const Color.fromRGBO(245, 245, 245, 1.0), // Light gray background
        onPrimary: Colors.white, // Text on primary color
        onSecondary: Colors.black, // Text on secondary color
      ),
      scaffoldBackgroundColor: const Color.fromRGBO(245, 245, 245, 1.0), // Light gray scaffold
      appBarTheme: const AppBarTheme(
        backgroundColor: Color.fromRGBO(0, 123, 255, 1.0),
        foregroundColor: Colors.white,
        elevation: 4.0,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromRGBO(0, 123, 255, 1.0),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Color.fromRGBO(33, 33, 33, 1.0)), // Dark text for body
        bodyMedium: TextStyle(color: Color.fromRGBO(66, 66, 66, 1.0)), // Medium gray for subtitles
        headlineSmall: TextStyle(
          color: Color.fromRGBO(0, 123, 255, 1.0),
          fontWeight: FontWeight.bold,
        ), // Primary color for headings
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Color.fromRGBO(0, 123, 255, 1.0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color.fromRGBO(255, 193, 7, 1.0), width: 2.0),
        ),
        labelStyle: TextStyle(color: Color.fromRGBO(0, 123, 255, 1.0)),
      ),

    );
  }
}
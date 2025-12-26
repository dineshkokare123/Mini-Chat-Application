import 'package:flutter/material.dart';

class AppTheme {
  // Colors
  static const Color primaryColor = Color(0xFF6C63FF); // Violet
  static const Color accentColor = Color(0xFF00BFA5); // Teal Accent
  static const Color backgroundColor = Color(0xFFF9FAFC); // Very light grey
  static const Color surfaceColor = Colors.white;
  static const Color textBody = Color(0xFF333333);
  static const Color textLight = Color(0xFF888888);
  static const Color errorColor = Color(0xFFE53935);

  static const Color bubbleSelf = Color(0xFF6C63FF);
  static const Color bubbleOther = Color(0xFFF0F2F5);

  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundColor,
      colorScheme: ColorScheme.fromSwatch().copyWith(
        primary: primaryColor,
        secondary: accentColor,
        surface: surfaceColor,
      ),
      textTheme: Typography.blackCupertino.apply(
        bodyColor: textBody,
        displayColor: textBody,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: backgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(color: textBody),
        titleTextStyle: TextStyle(
          color: textBody,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 4,
          shadowColor: primaryColor.withValues(alpha: 0.4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      cardTheme: CardThemeData(
        color: surfaceColor,
        elevation: 2,
        shadowColor: Colors.black.withValues(alpha: 0.05),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      ),
      useMaterial3: true,
    );
  }
}

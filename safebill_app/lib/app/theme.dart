import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SafeBillTheme {
  // Colors from Tailwind Slate palette
  static const slate50 = Color(0xFFF8FAFC);
  static const slate100 = Color(0xFFF1F5F9);
  static const slate200 = Color(0xFFE2E8F0);
  static const slate300 = Color(0xFFCBD5E1);
  static const slate400 = Color(0xFF94A3B8);
  static const slate500 = Color(0xFF64748B);
  static const slate600 = Color(0xFF475569);
  static const slate700 = Color(0xFF334155);
  static const slate800 = Color(0xFF1E293B);
  static const slate900 = Color(0xFF0F172A);
  static const slate950 = Color(0xFF020617);

  static const indigo200 = Color(0xFFC7D2FE);
  static const indigo500 = Color(0xFF6366F1);
  static const indigo600 = Color(0xFF4F46E5);

  static const rose500 = Color(0xFFF43F5E);
  static const emerald500 = Color(0xFF10B981);
  static const amber500 = Color(0xFFF59E0B);

  static TextTheme _buildTextTheme(TextTheme base) {
    return GoogleFonts.plusJakartaSansTextTheme(base);
  }

  static ThemeData light() {
    final base = ThemeData(brightness: Brightness.light, useMaterial3: true);

    return base.copyWith(
      scaffoldBackgroundColor: slate50,
      colorScheme: base.colorScheme.copyWith(
        primary: indigo600,
        secondary: indigo500,
        surface: Colors.white,
        onSurface: slate900,
        error: rose500,
        outline: slate200,
      ),
      textTheme: _buildTextTheme(
        base.textTheme,
      ).apply(bodyColor: slate900, displayColor: slate900),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: slate900,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(color: slate200),
        ),
        color: Colors.white,
        margin: EdgeInsets.zero,
      ),
    );
  }

  static ThemeData dark() {
    final base = ThemeData(brightness: Brightness.dark, useMaterial3: true);

    return base.copyWith(
      scaffoldBackgroundColor: slate950,
      colorScheme: base.colorScheme.copyWith(
        primary: indigo500,
        secondary: indigo600,
        surface: slate900,
        onSurface: Colors.white,
        error: rose500,
        outline: slate800,
      ),
      textTheme: _buildTextTheme(
        base.textTheme,
      ).apply(bodyColor: Colors.white, displayColor: Colors.white),
      appBarTheme: const AppBarTheme(
        backgroundColor: slate900,
        foregroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(color: slate800),
        ),
        color: slate900,
        margin: EdgeInsets.zero,
      ),
    );
  }
}

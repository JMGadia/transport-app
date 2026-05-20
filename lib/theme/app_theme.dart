import 'package:flutter/material.dart';

/// Centralized theme so colors & text styles stay consistent across the app.
/// Swap the [primary] color here to re-brand the entire UI.
class AppTheme {
  // Brand colors — tuned for a clean, professional transport/logistics look
  static const Color primary = Color(0xFF1E40AF); // deep blue
  static const Color primaryLight = Color(0xFF3B82F6); // accent blue
  static const Color success = Color(0xFF16A34A); // green (Billable)
  static const Color warning = Color(0xFFF59E0B); // amber (Complimentary)
  static const Color danger = Color(0xFFDC2626); // red (Unbillable)
  static const Color background = Color(0xFFF5F7FA);
  static const Color surface = Colors.white;
  static const Color textPrimary = Color(0xFF111827);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color border = Color(0xFFE5E7EB);

  static ThemeData get light => ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: background,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primary,
          primary: primary,
          surface: surface,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: false,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        cardTheme: CardThemeData(
          color: surface,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: border),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: surface,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: primary, width: 1.5),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            textStyle:
                const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
        ),
        dividerTheme: const DividerThemeData(color: border, thickness: 1),
      );
}

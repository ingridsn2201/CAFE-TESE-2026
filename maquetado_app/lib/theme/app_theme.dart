import 'package:flutter/material.dart';

class AppTheme {
  const AppTheme._();

  static const Color verdeInstitucional = Color(0xFF0B6B3A);
  static const Color verdeOscuro = Color(0xFF064B2A);
  static const Color doradoAccion = Color(0xFFE8A317);
  static const Color fondoClaro = Color(0xFFF7F8F5);
  static const Color textoPrincipal = Color(0xFF26312B);
  static const Color disponible = Color(0xFF18864B);
  static const Color agotado = Color(0xFFC0392B);
  static const Color pendiente = Color(0xFFE88924);

  static ThemeData light() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: verdeInstitucional,
      brightness: Brightness.light,
      primary: verdeInstitucional,
      secondary: doradoAccion,
      surface: Colors.white,
      error: agotado,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: fondoClaro,
      fontFamily: 'Roboto',
      appBarTheme: const AppBarTheme(
        centerTitle: false,
        backgroundColor: Colors.white,
        foregroundColor: textoPrincipal,
        elevation: 0,
        surfaceTintColor: Colors.white,
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: verdeInstitucional,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: verdeInstitucional,
          minimumSize: const Size.fromHeight(48),
          side: const BorderSide(color: verdeInstitucional),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: verdeInstitucional, width: 1.6),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: Colors.white,
        selectedColor: verdeInstitucional.withValues(alpha: 0.12),
        labelStyle: const TextStyle(color: textoPrincipal),
        side: BorderSide(color: Colors.grey.shade300),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}

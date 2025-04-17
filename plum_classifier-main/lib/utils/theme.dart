// lib/utils/theme.dart

import 'package:flutter/material.dart';

class AppTheme {
  // Couleurs principales - basées sur le bleu profond
  static const Color primaryColor = Color(0xFF1A5F7A); // Bleu foncé profond
  static const Color accentColor = Color(0xFF61A4BC); // Bleu ciel

  // Pour le mode clair
  static const Color backgroundColorLight = Color(0xFFF0F7FA); // Blanc cassé avec teinte bleue
  static const Color cardColorLight = Colors.white;
  static const Color textPrimaryLight = Color(0xFF333333);
  static const Color textSecondaryLight = Color(0xFF666666);

  // Pour le mode sombre - couleurs avec contraste amélioré
  static const Color backgroundColorDark = Color(0xFF0A1215); // Noir bleuté plus foncé
  static const Color cardColorDark = Color(0xFF152429); // Bleu-noir pour les cartes
  static const Color darkAccentColor = Color(0xFF78C4E0); // Bleu ciel plus clair pour meilleur contraste
  static const Color textPrimaryDark = Color(0xFFECF0F1); // Blanc cassé
  static const Color textSecondaryDark = Color(0xFFBDC3C7); // Gris clair

  // Couleur déconnexion & suppression (remplace le rouge)
  static const Color logoutColor = Color(0xFF3498DB); // Bleu vif au lieu de rouge
  
  // Couleurs pour les catégories de prunes
  static const Color goodQualityColor = Color(0xFF4CAF50); // Vert pour "bonne qualité"
  static const Color unripeColor = Color(0xFF8BC34A); // Vert clair pour "non mûre"
  static const Color spottedColor = Color(0xFF5E9CB4); // Bleu-gris pour "tachetée"  
  static const Color crackedColor = Color(0xFFFFB74D); // Orange clair pour "fissurée"
  static const Color bruisedColor = Color(0xFFFF9800); // Orange pour "meurtrie"
  static const Color rottenColor = Color(0xFFE53935); // Rouge pour "pourrie"

  // Thème clair
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: primaryColor,
    colorScheme: const ColorScheme.light(
      primary: primaryColor,
      secondary: accentColor,
      surface: cardColorLight,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: textPrimaryLight,
    ),
    scaffoldBackgroundColor: backgroundColorLight,
    cardTheme: const CardTheme(
      color: cardColorLight,
      elevation: 2,
      shadowColor: Colors.black12,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(color: textPrimaryLight),
      displayMedium: TextStyle(color: textPrimaryLight),
      displaySmall: TextStyle(color: textPrimaryLight),
      headlineLarge: TextStyle(color: textPrimaryLight),
      headlineMedium: TextStyle(color: textPrimaryLight),
      headlineSmall: TextStyle(color: textPrimaryLight),
      titleLarge: TextStyle(color: textPrimaryLight),
      titleMedium: TextStyle(color: textPrimaryLight),
      titleSmall: TextStyle(color: textPrimaryLight),
      bodyLarge: TextStyle(color: textPrimaryLight),
      bodyMedium: TextStyle(color: textPrimaryLight),
      bodySmall: TextStyle(color: textSecondaryLight),
      labelLarge: TextStyle(color: textPrimaryLight),
      labelMedium: TextStyle(color: textPrimaryLight),
      labelSmall: TextStyle(color: textSecondaryLight),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.transparent),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primaryColor, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    ),
    iconTheme: const IconThemeData(
      color: primaryColor,
    ),
  );

  // Thème sombre avec contraste amélioré
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: darkAccentColor,
    colorScheme: const ColorScheme.dark(
      primary: darkAccentColor, // Bleu plus clair pour meilleur contraste
      secondary: primaryColor,
      surface: cardColorDark,
      onPrimary: Color(0xFF0A1215), // Texte foncé sur fond clair
      onSecondary: Colors.white,
      onSurface: textPrimaryDark,
      error: logoutColor, // Remplacer le rouge par du bleu
    ),
    scaffoldBackgroundColor: backgroundColorDark,
    cardTheme: const CardTheme(
      color: cardColorDark,
      elevation: 4,
      shadowColor: Colors.black26,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF0C171B), // Encore plus foncé pour plus de contraste
      foregroundColor: darkAccentColor, // Titre en bleu clair pour meilleur contraste
      elevation: 0,
      iconTheme: IconThemeData(color: darkAccentColor),
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(color: textPrimaryDark),
      displayMedium: TextStyle(color: textPrimaryDark),
      displaySmall: TextStyle(color: textPrimaryDark),
      headlineLarge: TextStyle(color: textPrimaryDark),
      headlineMedium: TextStyle(color: textPrimaryDark),
      headlineSmall: TextStyle(color: textPrimaryDark),
      titleLarge: TextStyle(color: textPrimaryDark),
      titleMedium: TextStyle(color: textPrimaryDark),
      titleSmall: TextStyle(color: textPrimaryDark),
      bodyLarge: TextStyle(color: textPrimaryDark),
      bodyMedium: TextStyle(color: textPrimaryDark),
      bodySmall: TextStyle(color: textSecondaryDark),
      labelLarge: TextStyle(color: textPrimaryDark),
      labelMedium: TextStyle(color: textPrimaryDark),
      labelSmall: TextStyle(color: textSecondaryDark),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: darkAccentColor,
        foregroundColor: Color(0xFF0A1215), // Texte foncé sur fond clair
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Color(0xFF1A2429), // Plus clair pour meilleur contraste
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.transparent),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: darkAccentColor, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      labelStyle: TextStyle(color: darkAccentColor.withOpacity(0.8)),
      prefixIconColor: darkAccentColor.withOpacity(0.8),
    ),
    iconTheme: const IconThemeData(
      color: darkAccentColor,
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: darkAccentColor, // Bouton déconnexion en bleu
        side: BorderSide(color: darkAccentColor),
      ),
    ),
  );
}
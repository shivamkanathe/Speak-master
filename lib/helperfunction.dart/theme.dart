import 'package:communicate/helperfunction.dart/colors.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        background: AppColors.background,
        surface: AppColors.surface,
        error: AppColors.error,
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: AppColors.textPrimary,fontSize: 17),
        bodyMedium: TextStyle(color: AppColors.textSecondary),
      ),
      appBarTheme: const AppBarTheme(
        color: AppColors.appBarColor,
        elevation: 0,
      ),
      cardTheme: const CardThemeData( 
        color: AppColors.cardColor,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.secondary,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: AppColors.primaryDark,
      scaffoldBackgroundColor: Colors.black,
      colorScheme: ColorScheme.dark(
        primary: AppColors.primaryDark,
        secondary: AppColors.secondaryDark,
        background: Colors.black,
        surface: Color(0xFF121212),
        error: AppColors.error,
      ),
    );
  }
}

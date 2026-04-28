import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_theme_extension.dart';

abstract final class AppTheme {
  static ThemeData get light {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.brandGreen,
      brightness: Brightness.light,
    ).copyWith(
      // Pin exact brand values so widgets using colorScheme.primary
      // get the same green as AppColors.brandGreen.
      primary: AppColors.brandGreen,
      primaryContainer: AppColors.brandGreenLight,
      surface: AppColors.surfaceWhite,
      onSurface: AppColors.textPrimary,
      onSurfaceVariant: AppColors.textSecondary,
      outline: AppColors.borderLight,
      error: AppColors.statusRejectedFg,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.appBackground,
      extensions: [AppThemeExtension.light],
      textTheme: _buildTextTheme(),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.surfaceWhite,
        indicatorColor: AppColors.brandGreenLight,
      ),
    );
  }

  static TextTheme _buildTextTheme() {
    return const TextTheme(
      // Screen headings  (e.g. "KYC Verification" header)
      headlineMedium: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w800,
        color: AppColors.textPrimary,
        letterSpacing: 0.3,
      ),
      // Modal / sheet titles  (e.g. task detail, doc detail)
      titleLarge: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w800,
        color: AppColors.textPrimary,
      ),
      // Card titles  (e.g. document type label)
      titleMedium: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      ),
      // Section headers / button labels
      titleSmall: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      ),
      // Body emphasis
      bodyLarge: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
      // Body default
      bodyMedium: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        color: AppColors.textPrimary,
      ),
      // Secondary body / file names
      bodySmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
      ),
      // Primary labels
      labelLarge: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
      // Caption emphasis  (e.g. status badge text)
      labelMedium: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      ),
      // Caption default  (e.g. dates, stage names)
      labelSmall: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w400,
        color: AppColors.textTertiary,
      ),
    );
  }
}

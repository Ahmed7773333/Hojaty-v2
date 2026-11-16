import 'package:flutter/material.dart';
import '../../../../core/utils/app_colors.dart';

enum BookReaderThemeMode {
  vintage,
  light,
  dark,
}

class BookReaderThemeModel {
  final BookReaderThemeMode mode;
  final Color background;
  final Color surface;
  final Color border;
  final Color primaryText;
  final Color secondaryText;
  final Color accent;
  final Color badgeBackground;
  final Color badgeText;

  const BookReaderThemeModel({
    required this.mode,
    required this.background,
    required this.surface,
    required this.border,
    required this.primaryText,
    required this.secondaryText,
    required this.accent,
    required this.badgeBackground,
    required this.badgeText,
  });

  static const BookReaderThemeModel vintage = BookReaderThemeModel(
    mode: BookReaderThemeMode.vintage,
    background: Color(0xFFFAF7EE),
    surface: Color(0xFFF3EDDC),
    border: Color(0xFFDCCEA6),
    primaryText: Color(0xFF2B2317),
    secondaryText: Color(0xFF695944),
    accent: Color(0xFF9E772F),
    badgeBackground: Color(0xFF8B6B2B),
    badgeText: Color(0xFFFAF7EE),
  );

  static const BookReaderThemeModel light = BookReaderThemeModel(
    mode: BookReaderThemeMode.light,
    background: AppColors.lightBackground,
    surface: AppColors.lightSurface,
    border: AppColors.lightBorderUnselected,
    primaryText: AppColors.lightTextPrimary,
    secondaryText: AppColors.lightTextSecondary,
    accent: AppColors.primaryDark,
    badgeBackground: AppColors.primaryDark,
    badgeText: Colors.white,
  );

  static const BookReaderThemeModel dark = BookReaderThemeModel(
    mode: BookReaderThemeMode.dark,
    background: AppColors.mushafNightBackground,
    surface: Color(0xFF1B1E23),
    border: Color(0xFF2D333B),
    primaryText: AppColors.mushafNightText,
    secondaryText: Color(0xFF9EA7B0),
    accent: AppColors.mushafNightAccent,
    badgeBackground: Color(0xFF2D333B),
    badgeText: AppColors.accentGoldLight,
  );

  static BookReaderThemeModel fromMode(BookReaderThemeMode mode) {
    switch (mode) {
      case BookReaderThemeMode.vintage:
        return vintage;
      case BookReaderThemeMode.light:
        return light;
      case BookReaderThemeMode.dark:
        return dark;
    }
  }
}


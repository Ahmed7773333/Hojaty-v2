import 'package:flutter/material.dart';
import '../../config/theme/app_theme.dart';

class AppColors {
  // Brand Dark Greens
  static const Color primaryDark = Color(0xFF1D433F);
  static const Color primaryDarkHeader = Color(0xFF163532);
  static const Color brandPrimaryDarkBackground = Color(0xFF1B3B36);
  static const Color primaryDarkSurface = Color(0xFF244B45);
  static const Color primaryDarkCard = Color(0xFF1A3A3A);
  static const Color primaryDarkBorder = Color(0xFF2F5C55);
  static const Color darkBadgeOuter = Color(0xFF2A524C);
  static const Color darkBadgeInner = Color(0xFF1E3F3A);

  /// Dynamic Header / App Bar background that switches to AMOLED Black when AMOLED is active
  static Color get primaryDarkBackground =>
      AppTheme.isAmoled ? amoledBackground : brandPrimaryDarkBackground;

  // Brand Gold / Mustard Accents
  static const Color accentGold = Color(0xFFCCA142);
  static const Color accentGoldLight = Color(0xFFD8B257);
  static const Color accentGoldExtraLight = Color(0xFFF5EEDD);
  static const Color accentGoldDark = Color(0xFFB58E34);
  static const Color accentGoldDisabled = Color(0xFF8C7B4D);

  // Light Theme Palette
  static const Color lightBackground = Color(0xFFF9FBFB);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightCardSelected = Color(0xFFEBF4F2);
  static const Color lightCardUnselected = Color(0xFFFFFFFF);
  static const Color lightBorderSelected = Color(0xFF1D433F);
  static const Color lightBorderUnselected = Color(0xFFE5E7EB);
  static const Color lightTextPrimary = Color(0xFF111827);
  static const Color lightTextSecondary = Color(0xFF6B7280);
  static const Color lightTextMuted = Color(0xFF9CA3AF);

  // Dark Green Theme Constants (Islamic Dark)
  static const Color greenDarkBackground = Color(0xFF1B3B36);
  static const Color greenDarkSurface = Color(0xFF234943);
  static const Color greenDarkCardSelected = Color(0xFF27524C);
  static const Color greenDarkCardUnselected = Color(0xFF1F433E);
  static const Color greenDarkBorderSelected = Color(0xFFCCA142);
  static const Color greenDarkBorderUnselected = Color(0xFF2F5C55);
  static const Color greenDarkTextPrimary = Color(0xFFFFFFFF);
  static const Color greenDarkTextSecondary = Color(0xFFA3C4BE);
  static const Color greenDarkTextMuted = Color(0xFF759791);

  // AMOLED Theme Constants (Pure Pitch Black OLED)
  static const Color amoledBackground = Color(0xFF000000);
  static const Color amoledSurface = Color(0xFF0C0C0C);
  static const Color amoledCardSelected = Color(0xFF18181B);
  static const Color amoledCardUnselected = Color(0xFF0E0E10);
  static const Color amoledBorderSelected = Color(0xFFCCA142);
  static const Color amoledBorderUnselected = Color(0xFF27272A);
  static const Color amoledTextPrimary = Color(0xFFFFFFFF);
  static const Color amoledTextSecondary = Color(0xFFA1A1AA);
  static const Color amoledTextMuted = Color(0xFF71717A);

  // Dynamic Dark Palette (Automatically reflects Dark Green vs AMOLED)
  static Color get darkBackground =>
      AppTheme.isAmoled ? amoledBackground : greenDarkBackground;
  static Color get darkSurface =>
      AppTheme.isAmoled ? amoledSurface : greenDarkSurface;
  static Color get darkCardSelected =>
      AppTheme.isAmoled ? amoledCardSelected : greenDarkCardSelected;
  static Color get darkCardUnselected =>
      AppTheme.isAmoled ? amoledCardUnselected : greenDarkCardUnselected;
  static Color get darkBorderSelected =>
      AppTheme.isAmoled ? amoledBorderSelected : greenDarkBorderSelected;
  static Color get darkBorderUnselected =>
      AppTheme.isAmoled ? amoledBorderUnselected : greenDarkBorderUnselected;
  static Color get darkTextPrimary =>
      AppTheme.isAmoled ? amoledTextPrimary : greenDarkTextPrimary;
  static Color get darkTextSecondary =>
      AppTheme.isAmoled ? amoledTextSecondary : greenDarkTextSecondary;
  static Color get darkTextMuted =>
      AppTheme.isAmoled ? amoledTextMuted : greenDarkTextMuted;

  // Neutral / Common
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color transparent = Colors.transparent;

  // Mushaf Reader Palette
  static const Color mushafLightBackground = Color(0xFFFFFDF5);
  static const Color mushafNightBackground = Color(0xFF121417);
  static const Color mushafNightText = Color(0xFFECEFF1);
  static const Color mushafNightAccent = Color(0xFFC5A059);
}

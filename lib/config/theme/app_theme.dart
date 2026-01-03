import 'package:flutter/material.dart';

import 'app_color.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: AppColor.bgColor,
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: AppColor.tealPrimary,
      onPrimary: Colors.white,
      primaryContainer: AppColor.goldLight, // Warm gold instead of blue
      onPrimaryContainer: AppColor.secondaryColor,
      secondary: AppColor.goldAccent,
      onSecondary: Colors.white,
      secondaryContainer: AppColor.tealLight,
      onSecondaryContainer: AppColor.tealPrimary,
      tertiary: AppColor.greenLink,
      onTertiary: Colors.white,
      error: AppColor.error,
      onError: Colors.white,
      surface: AppColor.surfaceColor,
      onSurface: AppColor.secondaryColor,
      surfaceContainerHighest: AppColor.progressBarColor,
      outline: AppColor.onTertiary,
      outlineVariant: AppColor.onTertiary.withValues(alpha: 0.5),
    ),
    appBarTheme: const AppBarTheme(
      elevation: 0,
      centerTitle: true,
      backgroundColor: AppColor.primaryColor,
      foregroundColor: AppColor.secondaryColor,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: TextStyle(
        color: AppColor.secondaryColor,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    ),
    cardTheme: CardThemeData(
      color: AppColor.primaryColor,
      elevation: 2,
      shadowColor: AppColor.secondaryColor.withValues(alpha: 0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: AppColor.primaryColor,
      indicatorColor: AppColor.tealLight,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      elevation: 8,
      shadowColor: AppColor.secondaryColor.withValues(alpha: 0.15),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const IconThemeData(color: AppColor.tealPrimary);
        }
        return const IconThemeData(color: AppColor.onTertiary);
      }),
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const TextStyle(
            color: AppColor.tealPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          );
        }
        return const TextStyle(color: AppColor.onTertiary, fontSize: 12);
      }),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColor.tealPrimary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColor.goldAccent,
      foregroundColor: Colors.white,
    ),
    dividerTheme: DividerThemeData(
      color: AppColor.secondaryColor.withValues(alpha: 0.1),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColor.darkBackground,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColor.darkTeal,
      primary: AppColor.darkTeal,
      secondary: AppColor.darkGold,
      tertiary: AppColor.greenLink,
      surface: AppColor.darkSurface,
      onSurface: AppColor.darkTextPrimary,
      brightness: Brightness.dark,
    ),
    appBarTheme: const AppBarTheme(
      elevation: 0,
      centerTitle: true,
      backgroundColor: AppColor.darkSurface,
      foregroundColor: AppColor.darkTextPrimary,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: TextStyle(
        color: AppColor.darkTextPrimary,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    ),
    cardTheme: CardThemeData(
      color: AppColor.darkCard,
      elevation: 2,
      shadowColor: Colors.black38,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: AppColor.darkSurface,
      indicatorColor: AppColor.darkTeal.withValues(alpha: 0.2),
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      elevation: 8,
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const IconThemeData(color: AppColor.darkTeal);
        }
        return const IconThemeData(color: AppColor.darkTextSecondary);
      }),
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const TextStyle(
            color: AppColor.darkTeal,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          );
        }
        return const TextStyle(color: AppColor.darkTextSecondary, fontSize: 12);
      }),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColor.darkTeal,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColor.darkGold,
      foregroundColor: Colors.white,
    ),
    dividerTheme: DividerThemeData(
      color: AppColor.darkTextSecondary.withValues(alpha: 0.2),
    ),
  );
}

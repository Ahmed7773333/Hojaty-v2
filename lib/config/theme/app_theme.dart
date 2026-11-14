import 'package:flutter/material.dart';
import '../../core/local/user_hive_helper.dart';
import '../../core/utils/app_colors.dart';
import 'app_theme_mode.dart';

class AppTheme {
  static final ValueNotifier<AppThemeMode> themeModeNotifier =
      ValueNotifier<AppThemeMode>(UserHiveHelper.getThemeMode());

  static AppThemeMode get currentTheme => themeModeNotifier.value;
  static bool get isAmoled => currentTheme == AppThemeMode.amoled;
  static bool get isDark => currentTheme == AppThemeMode.dark;
  static bool get isLight => currentTheme == AppThemeMode.light;
  static bool get isAnyDark => currentTheme != AppThemeMode.light;

  static void setThemeMode(AppThemeMode mode) {
    themeModeNotifier.value = mode;
    UserHiveHelper.setThemeMode(mode);
  }

  static void toggleTheme() {
    final nextMode = switch (themeModeNotifier.value) {
      AppThemeMode.light => AppThemeMode.dark,
      AppThemeMode.dark => AppThemeMode.amoled,
      AppThemeMode.amoled => AppThemeMode.light,
    };
    setThemeMode(nextMode);
  }

  static ThemeData get activeTheme => switch (currentTheme) {
        AppThemeMode.light => lightTheme,
        AppThemeMode.dark => darkTheme,
        AppThemeMode.amoled => amoledTheme,
      };

  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.lightBackground,
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.primaryDark,
      onPrimary: AppColors.white,
      secondary: AppColors.accentGold,
      onSecondary: AppColors.white,
      error: Color(0xFFDC2626),
      onError: AppColors.white,
      surface: AppColors.lightSurface,
      onSurface: AppColors.lightTextPrimary,
      outline: AppColors.lightBorderUnselected,
      outlineVariant: AppColors.lightBorderSelected,
      surfaceContainerHighest: AppColors.lightCardSelected,
    ),
    appBarTheme: const AppBarTheme(
      elevation: 0,
      centerTitle: true,
      backgroundColor: AppColors.transparent,
      foregroundColor: AppColors.lightTextPrimary,
    ),
    cardTheme: CardThemeData(
      color: AppColors.lightSurface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
        side: const BorderSide(color: AppColors.lightBorderUnselected),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: AppColors.primaryDark,
        foregroundColor: AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28.0),
        ),
        textStyle: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w700),
      ),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.disabled)) {
          return AppColors.lightTextMuted;
        }
        return AppColors.white;
      }),
      trackColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.disabled)) {
          return AppColors.lightBorderUnselected.withValues(alpha: 0.5);
        }
        if (states.contains(WidgetState.selected)) {
          return AppColors.primaryDark;
        }
        return AppColors.lightBorderUnselected;
      }),
      trackOutlineColor: const WidgetStatePropertyAll(AppColors.transparent),
      trackOutlineWidth: const WidgetStatePropertyAll(0.0),
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontSize: 30.0,
        fontWeight: FontWeight.w800,
        color: AppColors.lightTextPrimary,
        height: 1.3,
      ),
      headlineMedium: TextStyle(
        fontSize: 24.0,
        fontWeight: FontWeight.w700,
        color: AppColors.lightTextPrimary,
        height: 1.3,
      ),
      titleLarge: TextStyle(
        fontSize: 20.0,
        fontWeight: FontWeight.w700,
        color: AppColors.lightTextPrimary,
      ),
      titleMedium: TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.w600,
        color: AppColors.lightTextPrimary,
      ),
      bodyLarge: TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.w400,
        color: AppColors.lightTextSecondary,
        height: 1.5,
      ),
      bodyMedium: TextStyle(
        fontSize: 14.0,
        fontWeight: FontWeight.w400,
        color: AppColors.lightTextSecondary,
        height: 1.5,
      ),
      labelLarge: TextStyle(
        fontSize: 14.0,
        fontWeight: FontWeight.w600,
        color: AppColors.accentGold,
      ),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.greenDarkBackground,
    colorScheme: const ColorScheme(
      brightness: Brightness.dark,
      primary: AppColors.accentGold,
      onPrimary: AppColors.brandPrimaryDarkBackground,
      secondary: AppColors.primaryDark,
      onSecondary: AppColors.white,
      error: Color(0xFFEF4444),
      onError: AppColors.white,
      surface: AppColors.greenDarkSurface,
      onSurface: AppColors.greenDarkTextPrimary,
      outline: AppColors.greenDarkBorderUnselected,
      outlineVariant: AppColors.greenDarkBorderSelected,
      surfaceContainerHighest: AppColors.greenDarkCardSelected,
    ),
    appBarTheme: const AppBarTheme(
      elevation: 0,
      centerTitle: true,
      backgroundColor: AppColors.transparent,
      foregroundColor: AppColors.greenDarkTextPrimary,
    ),
    cardTheme: CardThemeData(
      color: AppColors.greenDarkCardUnselected,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
        side: const BorderSide(color: AppColors.greenDarkBorderUnselected),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: AppColors.accentGold,
        foregroundColor: AppColors.brandPrimaryDarkBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28.0),
        ),
        textStyle: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w700),
      ),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.disabled)) {
          return AppColors.greenDarkTextMuted;
        }
        if (states.contains(WidgetState.selected)) {
          return AppColors.white;
        }
        return AppColors.greenDarkTextSecondary;
      }),
      trackColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.disabled)) {
          return AppColors.greenDarkBorderUnselected.withValues(alpha: 0.5);
        }
        if (states.contains(WidgetState.selected)) {
          return AppColors.accentGold;
        }
        return AppColors.greenDarkBorderUnselected;
      }),
      trackOutlineColor: const WidgetStatePropertyAll(AppColors.transparent),
      trackOutlineWidth: const WidgetStatePropertyAll(0.0),
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontSize: 30.0,
        fontWeight: FontWeight.w800,
        color: AppColors.greenDarkTextPrimary,
        height: 1.3,
      ),
      headlineMedium: TextStyle(
        fontSize: 24.0,
        fontWeight: FontWeight.w700,
        color: AppColors.greenDarkTextPrimary,
        height: 1.3,
      ),
      titleLarge: TextStyle(
        fontSize: 20.0,
        fontWeight: FontWeight.w700,
        color: AppColors.greenDarkTextPrimary,
      ),
      titleMedium: TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.w600,
        color: AppColors.greenDarkTextPrimary,
      ),
      bodyLarge: TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.w400,
        color: AppColors.greenDarkTextSecondary,
        height: 1.5,
      ),
      bodyMedium: TextStyle(
        fontSize: 14.0,
        fontWeight: FontWeight.w400,
        color: AppColors.greenDarkTextSecondary,
        height: 1.5,
      ),
      labelLarge: TextStyle(
        fontSize: 14.0,
        fontWeight: FontWeight.w600,
        color: AppColors.accentGoldLight,
      ),
    ),
  );

  static final ThemeData amoledTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.amoledBackground,
    colorScheme: const ColorScheme(
      brightness: Brightness.dark,
      primary: AppColors.accentGold,
      onPrimary: AppColors.amoledBackground,
      secondary: AppColors.primaryDark,
      onSecondary: AppColors.white,
      error: Color(0xFFEF4444),
      onError: AppColors.white,
      surface: AppColors.amoledSurface,
      onSurface: AppColors.amoledTextPrimary,
      outline: AppColors.amoledBorderUnselected,
      outlineVariant: AppColors.amoledBorderSelected,
      surfaceContainerHighest: AppColors.amoledCardSelected,
    ),
    appBarTheme: const AppBarTheme(
      elevation: 0,
      centerTitle: true,
      backgroundColor: AppColors.transparent,
      foregroundColor: AppColors.amoledTextPrimary,
    ),
    cardTheme: CardThemeData(
      color: AppColors.amoledCardUnselected,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
        side: const BorderSide(color: AppColors.amoledBorderUnselected),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: AppColors.accentGold,
        foregroundColor: AppColors.amoledBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28.0),
        ),
        textStyle: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w700),
      ),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.disabled)) {
          return AppColors.amoledTextMuted;
        }
        if (states.contains(WidgetState.selected)) {
          return AppColors.white;
        }
        return AppColors.amoledTextSecondary;
      }),
      trackColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.disabled)) {
          return AppColors.amoledBorderUnselected.withValues(alpha: 0.5);
        }
        if (states.contains(WidgetState.selected)) {
          return AppColors.accentGold;
        }
        return AppColors.amoledBorderUnselected;
      }),
      trackOutlineColor: const WidgetStatePropertyAll(AppColors.transparent),
      trackOutlineWidth: const WidgetStatePropertyAll(0.0),
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontSize: 30.0,
        fontWeight: FontWeight.w800,
        color: AppColors.amoledTextPrimary,
        height: 1.3,
      ),
      headlineMedium: TextStyle(
        fontSize: 24.0,
        fontWeight: FontWeight.w700,
        color: AppColors.amoledTextPrimary,
        height: 1.3,
      ),
      titleLarge: TextStyle(
        fontSize: 20.0,
        fontWeight: FontWeight.w700,
        color: AppColors.amoledTextPrimary,
      ),
      titleMedium: TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.w600,
        color: AppColors.amoledTextPrimary,
      ),
      bodyLarge: TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.w400,
        color: AppColors.amoledTextSecondary,
        height: 1.5,
      ),
      bodyMedium: TextStyle(
        fontSize: 14.0,
        fontWeight: FontWeight.w400,
        color: AppColors.amoledTextSecondary,
        height: 1.5,
      ),
      labelLarge: TextStyle(
        fontSize: 14.0,
        fontWeight: FontWeight.w600,
        color: AppColors.accentGoldLight,
      ),
    ),
  );
}

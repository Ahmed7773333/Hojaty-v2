import 'package:flutter/material.dart';

import 'app_color.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: AppColor.bgColor,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColor.greenLink,
      primary: AppColor.greenLink,
      secondary: AppColor.secondaryColor,
      surface: AppColor.surfaceColor,
      error: AppColor.error,
      brightness: Brightness.light,
    ),
    appBarTheme: const AppBarTheme(
      elevation: 0,
      centerTitle: true,
      backgroundColor: AppColor.primaryColor, // White
      foregroundColor: AppColor.secondaryColor, // Black
      surfaceTintColor: Colors.transparent,
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: AppColor.primaryColor,
      indicatorColor: AppColor.greenSoft,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const IconThemeData(color: AppColor.greenLink);
        }
        return const IconThemeData(color: AppColor.onTertiary);
      }),
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const TextStyle(
            color: AppColor.greenLink,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          );
        }
        return const TextStyle(
          color: AppColor.onTertiary,
          fontSize: 12,
        );
      }),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF121212),
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColor.greenLink,
      primary: AppColor.greenLink,
      brightness: Brightness.dark,
      surface: const Color(0xFF1E1E1E),
    ),
    appBarTheme: const AppBarTheme(
      elevation: 0,
      centerTitle: true,
      backgroundColor: Color(0xFF1E1E1E),
      foregroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: const Color(0xFF1E1E1E),
      indicatorColor: AppColor.greenLink.withOpacity(0.2),
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const IconThemeData(color: AppColor.greenLink);
        }
        return const IconThemeData(color: Colors.grey);
      }),
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const TextStyle(
            color: AppColor.greenLink,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          );
        }
        return const TextStyle(
          color: Colors.grey,
          fontSize: 12,
        );
      }),
    ),
  );
}

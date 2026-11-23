enum AppThemeMode {
  light,
  dark,
  amoled;

  bool get isLight => this == AppThemeMode.light;
  bool get isDark => this == AppThemeMode.dark;
  bool get isAmoled => this == AppThemeMode.amoled;
  bool get isAnyDark => this != AppThemeMode.light;
}


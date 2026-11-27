import 'package:material_ui/material_ui.dart';
import 'package:hojaty/config/theme/app_theme.dart';
import 'package:hojaty/config/theme/app_theme_mode.dart';

/// Propagates [AppThemeMode] changes synchronously across all routes and tabs,
/// including offstage IndexedStack tabs and Liquid Glass surfaces.
class AppThemeScope extends InheritedNotifier<ValueNotifier<AppThemeMode>> {
  const AppThemeScope({
    super.key,
    required ValueNotifier<AppThemeMode> notifier,
    required super.child,
  }) : super(notifier: notifier);

  static AppThemeMode of(BuildContext context) {
    final scope = context
        .dependOnInheritedWidgetOfExactType<AppThemeScope>();
    return scope?.notifier?.value ?? AppTheme.currentTheme;
  }

  static AppThemeMode read(BuildContext context) {
    final scope = context.getInheritedWidgetOfExactType<AppThemeScope>();
    return scope?.notifier?.value ?? AppTheme.currentTheme;
  }
}


import 'package:flutter/material.dart';
import '../../../../../config/routes/app_router.dart';
import '../../../../../config/theme/app_theme.dart';
import '../../../../../config/theme/app_theme_mode.dart';
import '../../../../../core/utils/extensions/context_extensions.dart';
import 'settings_tile_widget.dart';

class ThemeSettingsTileWidget extends StatelessWidget {
  const ThemeSettingsTileWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppThemeMode>(
      valueListenable: AppTheme.themeModeNotifier,
      builder: (context, themeMode, _) {
        final subtitle = switch (themeMode) {
          AppThemeMode.light => context.strings.lightThemeTitle,
          AppThemeMode.dark => context.strings.darkThemeTitle,
          AppThemeMode.amoled => context.strings.amoledThemeTitle,
        };

        return SettingsTileWidget(
          title: context.strings.themeSettingsTitle,
          subtitle: subtitle,
          onTap: () {
            context.pushNamed(AppRoutes.themeSettings);
          },
        );
      },
    );
  }
}


import 'package:material_ui/material_ui.dart';
import 'package:hojaty/config/theme/app_theme.dart';
import 'package:hojaty/config/theme/app_theme_mode.dart';
import 'package:hojaty/core/utils/app_colors.dart';
import 'package:hojaty/core/utils/extensions/context_extensions.dart';
import 'package:hojaty/core/utils/screen_util_like.dart';
import 'package:hojaty/core/widgets/liquid_glass_backdrop.dart';
import 'package:hojaty/features/homelayout/presentation/widgets/settings/settings_page_header_widget.dart';
import 'package:hojaty/features/homelayout/presentation/widgets/settings/theme_radio_card_widget.dart';

class ThemeSettingsPage extends StatelessWidget {
  const ThemeSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedTheme = context.appThemeMode;
    final isDark = selectedTheme != AppThemeMode.light;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkBackground
          : AppColors.lightBackground,
      body: LiquidGlassBackdrop(
        child: Column(
          children: [
            SettingsPageHeaderWidget(
              title: context.strings.themeSettingsTitle,
              subtitle: context.strings.themeSettingsSubtitle,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
                child: Column(
                  children: [
                    ThemeRadioCardWidget(
                      title: context.strings.lightThemeTitle,
                      subtitle: context.strings.lightThemeSubtitle,
                      mode: AppThemeMode.light,
                      isSelected: selectedTheme == AppThemeMode.light,
                      onTap: () => AppTheme.setThemeMode(AppThemeMode.light),
                    ),
                    ThemeRadioCardWidget(
                      title: context.strings.darkThemeTitle,
                      subtitle: context.strings.darkThemeSubtitle,
                      mode: AppThemeMode.dark,
                      isSelected: selectedTheme == AppThemeMode.dark,
                      onTap: () => AppTheme.setThemeMode(AppThemeMode.dark),
                    ),
                    ThemeRadioCardWidget(
                      title: context.strings.amoledThemeTitle,
                      subtitle: context.strings.amoledThemeSubtitle,
                      mode: AppThemeMode.amoled,
                      isSelected: selectedTheme == AppThemeMode.amoled,
                      onTap: () => AppTheme.setThemeMode(AppThemeMode.amoled),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

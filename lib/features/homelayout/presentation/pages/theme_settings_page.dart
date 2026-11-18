import 'package:material_ui/material_ui.dart';
import 'package:hojaty/config/theme/app_theme.dart';
import 'package:hojaty/config/theme/app_theme_mode.dart';
import 'package:hojaty/core/utils/app_colors.dart';
import 'package:hojaty/core/utils/extensions/context_extensions.dart';
import 'package:hojaty/core/utils/screen_util_like.dart';
import 'package:hojaty/features/homelayout/presentation/widgets/settings/settings_page_header_widget.dart';
import 'package:hojaty/features/homelayout/presentation/widgets/settings/theme_radio_card_widget.dart';

class ThemeSettingsPage extends StatefulWidget {
  const ThemeSettingsPage({super.key});

  @override
  State<ThemeSettingsPage> createState() => _ThemeSettingsPageState();
}

class _ThemeSettingsPageState extends State<ThemeSettingsPage> {
  late AppThemeMode _selectedTheme;

  @override
  void initState() {
    super.initState();
    _selectedTheme = AppTheme.currentTheme;
  }

  void _onThemeSelected(AppThemeMode mode) {
    setState(() {
      _selectedTheme = mode;
    });
    AppTheme.setThemeMode(mode);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkBackground
          : AppColors.lightBackground,
      body: Column(
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
                    isSelected: _selectedTheme == AppThemeMode.light,
                    onTap: () => _onThemeSelected(AppThemeMode.light),
                  ),
                  ThemeRadioCardWidget(
                    title: context.strings.darkThemeTitle,
                    subtitle: context.strings.darkThemeSubtitle,
                    mode: AppThemeMode.dark,
                    isSelected: _selectedTheme == AppThemeMode.dark,
                    onTap: () => _onThemeSelected(AppThemeMode.dark),
                  ),
                  ThemeRadioCardWidget(
                    title: context.strings.amoledThemeTitle,
                    subtitle: context.strings.amoledThemeSubtitle,
                    mode: AppThemeMode.amoled,
                    isSelected: _selectedTheme == AppThemeMode.amoled,
                    onTap: () => _onThemeSelected(AppThemeMode.amoled),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

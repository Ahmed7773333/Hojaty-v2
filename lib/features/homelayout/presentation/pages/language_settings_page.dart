import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/local/user_hive_helper.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/extensions/context_extensions.dart';
import '../../../../core/utils/screen_util_like.dart';
import '../bloc/homelayout_bloc.dart';
import '../bloc/homelayout_event.dart';
import '../widgets/settings/language_radio_card_widget.dart';
import '../widgets/settings/settings_page_header_widget.dart';

class LanguageSettingsPage extends StatefulWidget {
  const LanguageSettingsPage({super.key});

  @override
  State<LanguageSettingsPage> createState() => _LanguageSettingsPageState();
}

class _LanguageSettingsPageState extends State<LanguageSettingsPage> {
  late String _selectedLanguage;

  @override
  void initState() {
    super.initState();
    _selectedLanguage = UserHiveHelper.getUser()?.language ?? 'ar';
  }

  void _onLanguageSelected(String langCode) {
    setState(() {
      _selectedLanguage = langCode;
    });
    UserHiveHelper.getUser()?.languageSetter = langCode;
    context.read<HomelayoutBloc>().add(LoadOccasionsDataEvent(language: langCode));
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
            title: context.strings.languageSettingsTitle,
            subtitle: context.strings.languageSettingsSubtitle,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
              child: Column(
                children: [
                  LanguageRadioCardWidget(
                    title: context.strings.arabicLanguage,
                    subtitle: context.strings.arabicSubtitle,
                    isSelected: _selectedLanguage == 'ar',
                    onTap: () => _onLanguageSelected('ar'),
                  ),
                  LanguageRadioCardWidget(
                    title: context.strings.englishLanguage,
                    subtitle: context.strings.englishSubtitle,
                    isSelected: _selectedLanguage == 'en',
                    onTap: () => _onLanguageSelected('en'),
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

import 'package:flutter/material.dart';
import '../../../../config/routes/app_router.dart';
import '../../../../core/local/user_hive_helper.dart';
import '../../../../core/utils/extensions/context_extensions.dart';
import '../../../../core/utils/screen_util_like.dart';
import '../../../../shared/widgets/custom_elevated_button.dart';
import '../widgets/language_card_widget.dart';
import '../widgets/language_header_widget.dart';

class LanguageSelectionPage extends StatefulWidget {
  const LanguageSelectionPage({super.key});

  @override
  State<LanguageSelectionPage> createState() => _LanguageSelectionPageState();
}

class _LanguageSelectionPageState extends State<LanguageSelectionPage> {
  late String _selectedLanguage;

  @override
  void initState() {
    super.initState();
    final user = UserHiveHelper.getUser();
    _selectedLanguage = user?.language ?? 'ar';
  }

  void _onSelectLanguage(String code) {
    setState(() {
      _selectedLanguage = code;
    });
    final user = UserHiveHelper.getUser();
    if (user != null) {
      user.languageSetter = code;
    }
  }

  void _onContinue() {
    final user = UserHiveHelper.getUser();
    if (user != null) {
      user.languageSetter = _selectedLanguage;
    }
    context.pushReplacementNamed(AppRoutes.onboarding);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              40.ver,
              const LanguageHeaderWidget(),
              32.ver,
              LanguageCardWidget(
                title: context.strings.arabicLanguage,
                subtitle: context.strings.arabicSubtitle,
                isSelected: _selectedLanguage == 'ar',
                onTap: () => _onSelectLanguage('ar'),
              ),
              16.ver,
              LanguageCardWidget(
                title: context.strings.englishLanguage,
                subtitle: context.strings.englishSubtitle,
                isSelected: _selectedLanguage == 'en',
                onTap: () => _onSelectLanguage('en'),
              ),
              const Spacer(),
              CustomElevatedButton(
                text: context.strings.continueButton,
                onPressed: _onContinue,
              ),
              16.ver,
            ],
          ),
        ),
      ),
    );
  }
}

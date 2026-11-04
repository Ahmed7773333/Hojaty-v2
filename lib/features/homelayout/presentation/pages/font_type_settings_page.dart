import 'package:flutter/material.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/extensions/context_extensions.dart';
import '../../../../core/utils/screen_util_like.dart';
import '../../../../data/mocks/settings_mock_data.dart';
import '../widgets/settings/font_type_preview_card_widget.dart';
import '../widgets/settings/font_type_selection_card_widget.dart';
import '../widgets/settings/settings_page_header_widget.dart';

class FontTypeSettingsPage extends StatefulWidget {
  const FontTypeSettingsPage({super.key});

  @override
  State<FontTypeSettingsPage> createState() => _FontTypeSettingsPageState();
}

class _FontTypeSettingsPageState extends State<FontTypeSettingsPage> {
  String _selectedFontId = 'naskh';

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final fontTypes = SettingsMockData.fontTypes;

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: Column(
        children: [
          SettingsPageHeaderWidget(
            title: context.strings.fontTypeSettingsTitle,
            subtitle: context.strings.fontTypeSettingsSubtitle,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              child: Column(
                children: [
                  FontTypePreviewCardWidget(
                    selectedFontId: _selectedFontId,
                  ),
                  20.ver,
                  FontTypeSelectionCardWidget(
                    fontTypes: fontTypes,
                    selectedId: _selectedFontId,
                    onSelect: (id) => setState(() => _selectedFontId = id),
                  ),
                  24.ver,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:hojaty/core/utils/app_colors.dart';
import 'package:hojaty/core/utils/extensions/context_extensions.dart';
import 'package:hojaty/core/utils/screen_util_like.dart';
import 'package:hojaty/features/quran/constants/quran_constants.dart';
import 'package:material_ui/material_ui.dart';

class HifzSurahPickerDropdown extends StatelessWidget {
  final int selectedSurahId;
  final ValueChanged<int> onChanged;

  const HifzSurahPickerDropdown({
    super.key,
    required this.selectedSurahId,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final surahs = QuranConstants.surahMap.values.toList(growable: false);

    return DropdownButtonFormField<int>(
      initialValue: selectedSurahId,
      isExpanded: true,
      decoration: InputDecoration(
        labelText: context.strings.hifzSelectSurah,
        filled: true,
        fillColor:
            isDark ? AppColors.darkCardUnselected : AppColors.lightBackground,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.r),
        ),
      ),
      items: surahs
          .map(
            (s) => DropdownMenuItem<int>(
              value: s.number,
              child: Text(
                '${s.number}. ${isArabic ? s.name : s.englishName} (${s.ayahCount})',
                overflow: TextOverflow.ellipsis,
              ),
            ),
          )
          .toList(growable: false),
      onChanged: (value) {
        if (value != null) onChanged(value);
      },
    );
  }
}


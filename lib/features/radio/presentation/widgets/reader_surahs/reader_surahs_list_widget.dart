import 'package:hojaty/core/utils/app_colors.dart';
import 'package:hojaty/core/utils/extensions/context_extensions.dart';
import 'package:hojaty/core/utils/screen_util_like.dart';
import 'package:hojaty/features/quran/data/models/surah_info_model.dart';
import 'package:flutter/material.dart';
import 'reader_surah_tile_widget.dart';

class ReaderSurahsListWidget extends StatelessWidget {
  final List<SurahInfoModel> surahs;
  final ValueChanged<SurahInfoModel> onSurahSelected;

  const ReaderSurahsListWidget({
    super.key,
    required this.surahs,
    required this.onSurahSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    if (surahs.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 40.h),
          child: Text(
            context.strings.noSurahsFound,
            style: context.textTheme.bodyMedium?.copyWith(
              color: isDark
                  ? AppColors.darkTextMuted
                  : AppColors.lightTextMuted,
            ),
          ),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: surahs.length,
      separatorBuilder: (_, __) => 8.ver,
      itemBuilder: (context, index) {
        final surah = surahs[index];
        return ReaderSurahTileWidget(
          surah: surah,
          onTap: () => onSurahSelected(surah),
        );
      },
    );
  }
}

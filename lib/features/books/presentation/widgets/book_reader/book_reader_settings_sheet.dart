import 'package:flutter/material.dart';
import 'package:hojaty/core/utils/app_colors.dart';
import 'package:hojaty/core/utils/extensions/context_extensions.dart';
import 'package:hojaty/core/utils/screen_util_like.dart';
import 'package:hojaty/features/books/data/models/book_reader_theme_model.dart';
import 'package:hojaty/features/books/presentation/widgets/book_reader/book_reader_theme_card_widget.dart';

class BookReaderSettingsSheet extends StatelessWidget {
  final double fontSize;
  final BookReaderThemeMode currentThemeMode;
  final bool showEnglish;
  final ValueChanged<double> onFontSizeChanged;
  final ValueChanged<BookReaderThemeMode> onThemeChanged;
  final ValueChanged<bool> onToggleEnglish;

  const BookReaderSettingsSheet({
    super.key,
    required this.fontSize,
    required this.currentThemeMode,
    required this.showEnglish,
    required this.onFontSizeChanged,
    required this.onThemeChanged,
    required this.onToggleEnglish,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 40.w,
              height: 4.h,
              margin: EdgeInsets.only(bottom: 12.h),
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.darkBorderUnselected
                    : AppColors.lightBorderUnselected,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                context.strings.readerSettings,
                style: context.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.sp,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close_rounded),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          16.ver,

          // Font Size Section
          Text(
            context.strings.fontSize,
            style: context.textTheme.labelMedium?.copyWith(
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          8.ver,
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.darkBackground
                  : AppColors.lightBackground,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.text_decrease_rounded),
                  onPressed: fontSize > 14
                      ? () => onFontSizeChanged(fontSize - 2)
                      : null,
                ),
                Text(
                  '${fontSize.toInt()} sp',
                  style: context.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 14.sp,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.text_increase_rounded),
                  onPressed: fontSize < 26
                      ? () => onFontSizeChanged(fontSize + 2)
                      : null,
                ),
              ],
            ),
          ),

          16.ver,

          // Reading Themes Section
          Text(
            'نمط المظهر والقراءة',
            style: context.textTheme.labelMedium?.copyWith(
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          8.ver,
          Row(
            children: [
              Expanded(
                child: BookReaderThemeCardWidget(
                  label: context.strings.themeVintage,
                  icon: Icons.history_edu_rounded,
                  previewColor: const Color(0xFFFAF7EE),
                  textColor: const Color(0xFF2B2317),
                  isSelected: currentThemeMode == BookReaderThemeMode.vintage,
                  onTap: () => onThemeChanged(BookReaderThemeMode.vintage),
                ),
              ),
              8.hor,
              Expanded(
                child: BookReaderThemeCardWidget(
                  label: context.strings.themeLight,
                  icon: Icons.wb_sunny_rounded,
                  previewColor: Colors.white,
                  textColor: Colors.black87,
                  isSelected: currentThemeMode == BookReaderThemeMode.light,
                  onTap: () => onThemeChanged(BookReaderThemeMode.light),
                ),
              ),
              8.hor,
              Expanded(
                child: BookReaderThemeCardWidget(
                  label: context.strings.themeDark,
                  icon: Icons.nights_stay_rounded,
                  previewColor: const Color(0xFF14171A),
                  textColor: Colors.white,
                  isSelected: currentThemeMode == BookReaderThemeMode.dark,
                  onTap: () => onThemeChanged(BookReaderThemeMode.dark),
                ),
              ),
            ],
          ),

          16.ver,

          // English Translation Toggle
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(
              context.strings.englishTranslation,
              style: context.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
                fontSize: 13.sp,
              ),
            ),
            value: showEnglish,
            onChanged: onToggleEnglish,
          ),
          10.ver,
        ],
      ),
    );
  }
}

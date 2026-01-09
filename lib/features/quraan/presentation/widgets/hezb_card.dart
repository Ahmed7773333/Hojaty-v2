import 'package:flutter/material.dart';
import 'package:hojaty/config/theme/app_color.dart';
import 'package:hojaty/core/constants/app_constants.dart';
import 'package:hojaty/core/utils/helper.dart';

import '../../../../config/theme/app_text_styles.dart';
import '../../../../core/utils/extensions/context_extensions.dart';
import '../../../../core/utils/screen_util_like.dart';
import 'quarter_card.dart';

class HizbCard extends StatelessWidget {
  final int index;
  final Animation<double> animation;

  const HizbCard({super.key, required this.index, required this.animation});

  @override
  Widget build(BuildContext context) {
    final hizb1 = AppConstants.hezbs[index * 2];
    final hizb2 = AppConstants.hezbs[(index * 2) + 1];

    return FadeTransition(
      opacity: animation,
      child: Padding(
        padding: EdgeInsets.only(bottom: 16.h),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          elevation: 8,
          color: context.isDarkMode ? AppColor.darkCard : Colors.grey.shade100,
          child: Padding(
            padding: EdgeInsets.all(20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Center(
                  child: Text(
                    Helper.convertToArabicJuzs(index + 1),
                    style: AppTextStyles.notoKufiArabicHeading24.copyWith(
                      color: AppColor.secondaryColor,
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                Text(
                  Helper.convertToArabicHizbs((index * 2) + 1),
                  style: AppTextStyles.notoKufiArabicHeading20.copyWith(
                    color: context.isDarkMode
                        ? AppColor.darkTextPrimary
                        : Colors.black87,
                  ),
                ),
                SizedBox(height: 12.h),
                QuarterCard(
                  title: context.strings.firstQuarter,
                  surah: hizb1.firstQuarterVerse.first,
                  verse: hizb1.firstQuarterVerse.last,
                  animation: animation,
                ),
                QuarterCard(
                  title: context.strings.secondQuarter,
                  surah: hizb1.secondQuarterVerse.first,
                  verse: hizb1.secondQuarterVerse.last,
                  animation: animation,
                ),
                QuarterCard(
                  title: context.strings.thirdQuarter,
                  surah: hizb1.thirdQuarterVerse.first,
                  verse: hizb1.thirdQuarterVerse.last,
                  animation: animation,
                ),
                QuarterCard(
                  title: context.strings.fourthQuarter,
                  surah: hizb1.fourthQuarterVerse.first,
                  verse: hizb1.fourthQuarterVerse.last,
                  animation: animation,
                ),
                SizedBox(height: 16.h),
                Text(
                  Helper.convertToArabicHizbs((index * 2) + 2),
                  style: AppTextStyles.notoKufiArabicHeading20.copyWith(
                    color: context.isDarkMode
                        ? AppColor.darkTextPrimary
                        : Colors.black87,
                  ),
                ),
                SizedBox(height: 12.h),
                QuarterCard(
                  title: context.strings.firstQuarter,
                  surah: hizb2.firstQuarterVerse.first,
                  verse: hizb2.firstQuarterVerse.last,
                  animation: animation,
                ),
                QuarterCard(
                  title: context.strings.secondQuarter,
                  surah: hizb2.secondQuarterVerse.first,
                  verse: hizb2.secondQuarterVerse.last,
                  animation: animation,
                ),
                QuarterCard(
                  title: context.strings.thirdQuarter,
                  surah: hizb2.thirdQuarterVerse.first,
                  verse: hizb2.thirdQuarterVerse.last,
                  animation: animation,
                ),
                QuarterCard(
                  title: context.strings.fourthQuarter,
                  surah: hizb2.fourthQuarterVerse.first,
                  verse: hizb2.fourthQuarterVerse.last,
                  animation: animation,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

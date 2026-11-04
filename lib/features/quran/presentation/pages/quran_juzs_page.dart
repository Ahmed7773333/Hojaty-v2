import 'package:flutter/material.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/extensions/context_extensions.dart';
import '../../../../core/utils/screen_util_like.dart';
import '../widgets/quran_juz_card_widget.dart';

class QuranJuzsPage extends StatelessWidget {
  const QuranJuzsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: AppBar(
        title: Text(
          context.strings.quranJuzs,
          style: context.textTheme.titleLarge?.copyWith(
            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
            fontWeight: FontWeight.w800,
            fontSize: 20.sp,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
            size: 20.sp,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: ListView.builder(
          itemCount: 30,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
          itemBuilder: (context, index) {
            return QuranJuzCardWidget(
              index: index,
              onQuarterTap: (pageNum) {
                Navigator.of(context).pop(pageNum);
              },
            );
          },
        ),
      ),
    );
  }
}

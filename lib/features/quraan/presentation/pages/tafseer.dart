import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/extensions/context_extensions.dart';
import '../../../../core/utils/screen_util_like.dart';
import '../../../../config/theme/app_color.dart';
import '../../../../config/theme/app_text_styles.dart';

class TafseerPage extends StatelessWidget {
  const TafseerPage({super.key, required this.content, required this.pageNum});

  final String content;
  final String pageNum;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(
        0xFFFFF8E1,
      ), // AppColor.quranPage matches this? Using direct color to be safe/consistent
      appBar: AppBar(
        title: Text(
          '${context.strings.quranTafseer} ${context.strings.quranPageLabel} $pageNum',
          style: AppTextStyles.notoKufiArabicHeading24,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: Text(
            content,
            textAlign: TextAlign.justify,
            textDirection: TextDirection.rtl,
            style: AppTextStyles.notoKufiArabicHeading20.copyWith(
              color: AppColor.secondaryColor,
            ),
          ),
        ),
      ),
    );
  }
}

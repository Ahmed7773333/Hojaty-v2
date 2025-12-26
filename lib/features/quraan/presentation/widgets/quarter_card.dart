import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hojaty/config/theme/app_color.dart';
import 'package:hojaty/core/utils/extensions/context_extensions.dart';
import 'package:hojaty/core/utils/screen_util_like.dart';
import 'package:hojaty/core/utils/helper.dart';
import '../bloc/quraan_bloc.dart';
import '../bloc/quraan_event.dart';
import '../../../../config/theme/app_text_styles.dart';

class QuarterCard extends StatelessWidget {
  final String title;
  final int surah;
  final int verse;
  final Animation<double> animation;

  const QuarterCard({
    super.key,
    required this.title,
    required this.surah,
    required this.verse,
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    // Helper.getPageNumberr returns 0-based index
    final pageIndex = Helper.getPageNumberr(surah, verse);
    final pageNum = pageIndex + 1;

    return FadeTransition(
      opacity: animation,
      child: Card(
        color: AppColor.primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14.r),
          side: const BorderSide(color: AppColor.secondaryColor, width: 1.4),
        ),
        elevation: 6,
        margin: EdgeInsets.symmetric(vertical: 6.h),
        child: InkWell(
          borderRadius: BorderRadius.circular(14.r),
          onTap: () {
            context.read<QuraanBloc>().add(JumpToPage(pageNum));
            Navigator.pop(context);
          },
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _buildVerseText(context, pageNum),
                SizedBox(height: 12.h),
                Text(
                  '${context.strings.safha} $pageNum',
                  style: AppTextStyles.hafsSmartStyle.copyWith(
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVerseText(BuildContext context, int pageNum) {
    // If we have access to Bloc state, use it.
    // Since we are inside BlocProvider.value (from QuraanPage -> Guzs -> HizbCard -> QuarterCard)
    // we can use context.read/watch.
    // Typically accessing state in build method:
    final state = context.watch<QuraanBloc>().state;
    // or context.read if not rebuilding on state change?
    // If data is loaded once, read is fine? But if loading...
    // Watch is safer.

    final pageData = state.quranPages[pageNum];
    String content = '';

    if (pageData != null) {
      final index = pageData.versesNumbers?.indexOf(verse) ?? -1;
      if (index != -1) {
        content = pageData.versesContent?[index] ?? '';
      } else {
        // Fallback if verse number not found in indexes?
        // Try to find by iteration if needed or just empty
      }
    }

    return Text(
      '$title: $content',
      textAlign: TextAlign.justify,
      textDirection: TextDirection.rtl,
      style: AppTextStyles.hafsSmartStyle.copyWith(),
    );
  }
}

import 'package:hojaty/core/utils/app_colors.dart';
import 'package:hojaty/core/utils/extensions/context_extensions.dart';
import 'package:hojaty/core/utils/screen_util_like.dart';
import 'package:flutter/material.dart';

class BookChaptersHeaderWidget extends StatelessWidget {
  final String title;
  final String author;
  final int totalHadiths;
  final VoidCallback onBack;
  final VoidCallback? onReadBook;
  final VoidCallback? onOpenPdf;

  const BookChaptersHeaderWidget({
    super.key,
    required this.title,
    required this.author,
    required this.totalHadiths,
    required this.onBack,
    this.onReadBook,
    this.onOpenPdf,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 12.h,
        bottom: 16.h,
        left: 20.w,
        right: 20.w,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.primaryDarkHeader : AppColors.primaryDark,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(20.r)),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: onBack,
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.white,
              size: 20.sp,
            ),
          ),
          8.hor,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: context.textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 16.sp,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                2.ver,
                Text(
                  '$author • $totalHadiths ${context.strings.hadithWord}',
                  style: context.textTheme.bodySmall?.copyWith(
                    color: AppColors.accentGoldLight,
                    fontSize: 11.sp,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          if (onOpenPdf != null) ...[
            8.hor,
            IconButton(
              onPressed: onOpenPdf,
              icon: Icon(
                Icons.picture_as_pdf_rounded,
                color: Colors.white,
                size: 22.sp,
              ),
              tooltip: context.strings.viewPdf,
            ),
          ],
          if (onReadBook != null) ...[
            8.hor,
            IconButton(
              onPressed: onReadBook,
              icon: Icon(
                Icons.auto_stories_rounded,
                color: Colors.white,
                size: 22.sp,
              ),
              tooltip: context.strings.readFullBook,
            ),
          ],
        ],
      ),
    );
  }
}

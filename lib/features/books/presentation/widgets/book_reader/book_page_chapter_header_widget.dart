import 'package:flutter/material.dart';
import 'package:hojaty/core/utils/extensions/context_extensions.dart';
import 'package:hojaty/core/utils/screen_util_like.dart';
import 'package:hojaty/features/books/data/models/book_reader_theme_model.dart';

class BookPageChapterHeaderWidget extends StatelessWidget {
  final String title;
  final BookReaderThemeModel theme;

  const BookPageChapterHeaderWidget({
    super.key,
    required this.title,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    if (title.isEmpty) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 16.h, top: 4.h),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: theme.surface,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: theme.border, width: 1.2),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.auto_stories_rounded,
                size: 16.sp,
                color: theme.accent,
              ),
              8.hor,
              Flexible(
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: context.textTheme.titleMedium?.copyWith(
                    color: theme.primaryText,
                    fontWeight: FontWeight.bold,
                    fontSize: 15.sp,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

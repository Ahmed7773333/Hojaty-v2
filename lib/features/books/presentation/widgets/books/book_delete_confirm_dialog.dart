import 'package:flutter/material.dart';
import 'package:hojaty/core/utils/app_colors.dart';
import 'package:hojaty/core/utils/extensions/context_extensions.dart';
import 'package:hojaty/core/utils/screen_util_like.dart';
import 'package:hojaty/features/books/data/models/book_info_model.dart';
import 'package:hojaty/features/books/presentation/widgets/books/book_delete_confirm_dialog_actions_widget.dart';

class BookDeleteConfirmDialog extends StatelessWidget {
  final BookInfoModel book;

  const BookDeleteConfirmDialog({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final errorColor = Theme.of(context).colorScheme.error;

    return Dialog(
      backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
        side: BorderSide(
          color: isDark
              ? AppColors.darkBorderUnselected
              : AppColors.lightBorderUnselected,
        ),
      ),
      insetPadding: EdgeInsets.symmetric(horizontal: 28.w),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 56.r,
              height: 56.r,
              decoration: BoxDecoration(
                color: errorColor.withValues(alpha: isDark ? 0.2 : 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.delete_outline_rounded,
                color: errorColor,
                size: 28.r,
              ),
            ),
            16.ver,
            Text(
              context.strings.deleteBookConfirmTitle,
              style: context.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 18.sp,
              ),
              textAlign: TextAlign.center,
            ),
            8.ver,
            Text(
              context.strings.deleteBookConfirmDesc(book.getDisplayTitle(isAr)),
              style: context.textTheme.bodyMedium?.copyWith(
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
                fontSize: 14.sp,
              ),
              textAlign: TextAlign.center,
            ),
            24.ver,
            const BookDeleteConfirmDialogActionsWidget(),
          ],
        ),
      ),
    );
  }
}

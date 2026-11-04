import 'package:hojaty/core/utils/app_colors.dart';
import 'package:hojaty/core/utils/extensions/context_extensions.dart';
import 'package:hojaty/core/utils/screen_util_like.dart';
import 'package:hojaty/features/books/data/models/book_info_model.dart';
import 'package:flutter/material.dart';

class BooksCategoryFilterWidget extends StatelessWidget {
  final BookCategory? selectedCategory;
  final ValueChanged<BookCategory?> onCategorySelected;

  const BooksCategoryFilterWidget({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    final categories = <(BookCategory?, String)>[
      (null, context.strings.allCategory),
      (BookCategory.nineBooks, context.strings.nineBooksCategory),
      (BookCategory.forties, context.strings.fortiesCategory),
      (BookCategory.other, context.strings.otherBooksCategory),
    ];

    return SizedBox(
      height: 38.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, __) => 8.hor,
        itemBuilder: (context, index) {
          final (cat, label) = categories[index];
          final isSelected = selectedCategory == cat;

          return InkWell(
            onTap: () => onCategorySelected(cat),
            borderRadius: BorderRadius.circular(20.r),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: isSelected
                    ? (isDark ? AppColors.accentGold : AppColors.primaryDark)
                    : (isDark
                          ? AppColors.darkCardUnselected
                          : AppColors.lightSurface),
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(
                  color: isSelected
                      ? (isDark ? AppColors.accentGold : AppColors.primaryDark)
                      : (isDark
                            ? AppColors.darkBorderUnselected
                            : AppColors.lightBorderUnselected),
                ),
              ),
              child: Center(
                child: Text(
                  label,
                  style: context.textTheme.labelMedium?.copyWith(
                    color: isSelected
                        ? (isDark ? AppColors.darkBackground : Colors.white)
                        : (isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.lightTextSecondary),
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    fontSize: 12.sp,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

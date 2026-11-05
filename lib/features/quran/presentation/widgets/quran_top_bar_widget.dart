import 'package:flutter/material.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/extensions/context_extensions.dart';
import '../../../../core/utils/screen_util_like.dart';
import 'quran_bar_item_widget.dart';

class QuranTopBarWidget extends StatelessWidget {
  final bool isVisible;
  final VoidCallback onTafseerTap;
  final VoidCallback onJuzsTap;
  final VoidCallback onSearchTap;
  final VoidCallback onFehresTap;
  final int currentPage;

  const QuranTopBarWidget({
    super.key,
    required this.isVisible,
    required this.onTafseerTap,
    required this.onJuzsTap,
    required this.onSearchTap,
    required this.onFehresTap,
    required this.currentPage,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return AnimatedPositioned(
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeInOut,
      top: isVisible ? 0 : -140,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + 8.h,
          bottom: 12.h,
          left: 16.w,
          right: 16.w,
        ),
        decoration: BoxDecoration(
          color: isDark
              ? AppColors.darkSurface.withValues(alpha: 0.95)
              : AppColors.lightSurface.withValues(alpha: 0.95),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
          border: Border(
            bottom: BorderSide(
              color: isDark
                  ? AppColors.darkBorderUnselected.withValues(alpha: 0.5)
                  : AppColors.lightBorderUnselected,
              width: 1,
            ),
          ),
        ),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              QuranBarItemWidget(
                label: context.strings.surahs_list,
                icon: Icons.format_list_bulleted_rounded,
                onTap: onFehresTap,
              ),
              QuranBarItemWidget(
                label: context.strings.quranSearch,
                icon: Icons.search_rounded,
                onTap: onSearchTap,
              ),
              // QuranBarItemWidget(
              //   label: context.strings.quranJuzs,
              //   icon: Icons.auto_stories_rounded,
              //   onTap: onJuzsTap,
              // ),
              QuranBarItemWidget(
                label: context.strings.quranTafseer,
                icon: Icons.menu_book_rounded,
                onTap: onTafseerTap,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/extensions/context_extensions.dart';
import '../../../../../core/utils/screen_util_like.dart';
import 'quran_search_field_widget.dart';

class QuranHeaderWidget extends StatelessWidget {
  final ValueChanged<String> onSearchChanged;
  final TextEditingController? searchController;
  final bool showBackButton;
  final VoidCallback? onBackPressed;

  const QuranHeaderWidget({
    super.key,
    required this.onSearchChanged,
    this.searchController,
    this.showBackButton = false,
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.primaryDarkBackground,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (showBackButton) ...[
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: AppColors.white,
                      size: 20.sp,
                    ),
                    onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
                  ),
                  12.hor,
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.strings.quranKareem,
                        style: context.textTheme.headlineMedium?.copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 26.sp,
                        ),
                      ),
                      4.ver,
                      Text(
                        context.strings.quranStatsSubtitle,
                        style: context.textTheme.bodySmall?.copyWith(
                          color: AppColors.darkTextSecondary,
                          fontSize: 13.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            16.ver,
            QuranSearchFieldWidget(
              controller: searchController,
              onChanged: onSearchChanged,
            ),
          ],
        ),
      ),
    );
  }
}

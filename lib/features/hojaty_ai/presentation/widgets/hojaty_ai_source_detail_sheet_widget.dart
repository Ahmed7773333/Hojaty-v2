import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/extensions/context_extensions.dart';
import '../../../../core/utils/screen_util_like.dart';
import '../../../../core/utils/snackbar_helper.dart';
import '../../data/models/rag_chunk_model.dart';

class HojatyAiSourceDetailSheetWidget extends StatelessWidget {
  final RagChunkModel source;

  const HojatyAiSourceDetailSheetWidget({
    super.key,
    required this.source,
  });

  static Future<void> show(BuildContext context, RagChunkModel source) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => HojatyAiSourceDetailSheetWidget(source: source),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.75,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        border: Border.all(
          color: isDark
              ? AppColors.darkBorderUnselected
              : AppColors.lightBorderUnselected,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          12.ver,
          Container(
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkTextMuted : AppColors.lightBorderUnselected,
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          16.ver,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: AppColors.accentGold.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(color: AppColors.accentGold.withValues(alpha: 0.3)),
                  ),
                  child: Text(
                    source.category,
                    style: context.textTheme.labelSmall?.copyWith(
                      color: isDark ? AppColors.accentGoldLight : AppColors.accentGoldDark,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                8.hor,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        source.sourceTitle,
                        style: context.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: 15.sp,
                          color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                        ),
                      ),
                      if (source.reference.isNotEmpty)
                        Text(
                          source.reference,
                          style: context.textTheme.bodySmall?.copyWith(
                            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                            fontSize: 12.sp,
                          ),
                        ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
          12.ver,
          const Divider(height: 1),
          Flexible(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(16.r),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkBackground : AppColors.lightBackground,
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(
                    color: isDark
                        ? AppColors.darkBorderUnselected
                        : AppColors.lightBorderUnselected,
                  ),
                ),
                child: SelectableText(
                  source.content,
                  style: context.textTheme.bodyLarge?.copyWith(
                    color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                    height: 1.8,
                    fontSize: 15.sp,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.r),
            child: SizedBox(
              width: double.infinity,
              height: 48.h,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.copy_rounded, size: 18),
                label: Text(context.strings.hojatyAiCopyText),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryDark,
                  foregroundColor: AppColors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                ),
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: '${source.sourceTitle} - ${source.reference}\n${source.content}'));
                  HapticFeedback.lightImpact();
                  Navigator.of(context).pop();
                  SnackbarHelper.showSuccess(
                    context,
                    message: context.strings.hojatyAiTextCopied,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}


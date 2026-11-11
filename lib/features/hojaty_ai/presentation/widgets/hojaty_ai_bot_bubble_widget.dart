import 'package:flutter/material.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/extensions/context_extensions.dart';
import '../../../../core/utils/screen_util_like.dart';
import '../../data/models/chat_message_model.dart';
import 'hojaty_ai_sources_section_widget.dart';

class HojatyAiBotBubbleWidget extends StatelessWidget {
  final ChatMessageModel message;

  const HojatyAiBotBubbleWidget({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.88,
        ),
        margin: EdgeInsets.only(bottom: 14.h),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(18.r),
            topRight: Radius.circular(18.r),
            bottomRight: Radius.circular(18.r),
            bottomLeft: Radius.circular(4.r),
          ),
          border: Border.all(
            color: isDark
                ? AppColors.darkBorderUnselected
                : AppColors.lightBorderUnselected,
            width: 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(
                alpha: isDark ? 0.2 : 0.04,
              ),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 24.w,
                  height: 24.h,
                  decoration: BoxDecoration(
                    color: AppColors.accentGold.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.auto_awesome,
                    color: isDark
                        ? AppColors.accentGoldLight
                        : AppColors.accentGoldDark,
                    size: 13.r,
                  ),
                ),
                8.hor,
                Text(
                  context.strings.hojatyAiTitle,
                  style: context.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                    fontSize: 11.sp,
                  ),
                ),
                if (message.isOffline) ...[
                  8.hor,
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                    decoration: BoxDecoration(
                      color: AppColors.accentGold.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: Text(
                      context.strings.offlineAvailable,
                      style: context.textTheme.labelSmall?.copyWith(
                        fontSize: 9.sp,
                        color: isDark
                            ? AppColors.accentGoldLight
                            : AppColors.accentGoldDark,
                      ),
                    ),
                  ),
                ],
              ],
            ),
            10.ver,
            SelectableText(
              message.text,
              style: context.textTheme.bodyMedium?.copyWith(
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.lightTextPrimary,
                fontSize: 14.sp,
                height: 1.7,
              ),
            ),
            if (message.sources.isNotEmpty) ...[
              12.ver,
              const Divider(height: 1),
              HojatyAiSourcesSectionWidget(sources: message.sources),
            ],
          ],
        ),
      ),
    );
  }
}


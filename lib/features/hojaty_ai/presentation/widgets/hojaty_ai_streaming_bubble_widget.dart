import 'package:flutter/material.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/extensions/context_extensions.dart';
import '../../../../core/utils/screen_util_like.dart';
import '../../data/models/rag_chunk_model.dart';
import 'hojaty_ai_sources_section_widget.dart';

class HojatyAiStreamingBubbleWidget extends StatelessWidget {
  final String text;
  final List<RagChunkModel> sources;

  const HojatyAiStreamingBubbleWidget({
    super.key,
    required this.text,
    required this.sources,
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
            color: AppColors.accentGold.withValues(alpha: 0.4),
            width: 1.2,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SizedBox(
                  width: 14.r,
                  height: 14.r,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.0,
                    color: isDark
                        ? AppColors.accentGoldLight
                        : AppColors.accentGoldDark,
                  ),
                ),
                8.hor,
                Text(
                  context.strings.hojatyAiTitle,
                  style: context.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: isDark
                        ? AppColors.accentGoldLight
                        : AppColors.accentGoldDark,
                    fontSize: 11.sp,
                  ),
                ),
              ],
            ),
            10.ver,
            if (text.isEmpty)
              Text(
                context.strings.hojatyAiThinking,
                style: context.textTheme.bodyMedium?.copyWith(
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
                  fontSize: 13.sp,
                  fontStyle: FontStyle.italic,
                ),
              )
            else
              SelectableText(
                text,
                style: context.textTheme.bodyMedium?.copyWith(
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.lightTextPrimary,
                  fontSize: 14.sp,
                  height: 1.7,
                ),
              ),
            if (sources.isNotEmpty) ...[
              12.ver,
              const Divider(height: 1),
              HojatyAiSourcesSectionWidget(sources: sources),
            ],
          ],
        ),
      ),
    );
  }
}


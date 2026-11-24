import 'package:material_ui/material_ui.dart';
import 'package:hojaty/core/utils/app_colors.dart';
import 'package:hojaty/core/utils/extensions/context_extensions.dart';
import 'package:hojaty/core/utils/screen_util_like.dart';
import 'package:hojaty/features/hojaty_ai/data/models/rag_chunk_model.dart';
import 'package:hojaty/features/hojaty_ai/presentation/bloc/hojaty_ai_state.dart';
import 'package:hojaty/features/hojaty_ai/presentation/widgets/hojaty_ai_sources_section_widget.dart';
import 'package:hojaty/features/hojaty_ai/presentation/widgets/hojaty_ai_status_pill_widget.dart';

class HojatyAiStreamingBubbleWidget extends StatelessWidget {
  final String text;
  final List<RagChunkModel> sources;
  final HojatyAiProcessingStage processingStage;

  const HojatyAiStreamingBubbleWidget({
    super.key,
    required this.text,
    required this.sources,
    required this.processingStage,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final effectiveStage = processingStage == HojatyAiProcessingStage.idle
        ? HojatyAiProcessingStage.generating
        : processingStage;

    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.88,
        ),
        margin: EdgeInsetsDirectional.only(bottom: 14.h),
        padding: EdgeInsetsDirectional.symmetric(
          horizontal: 16.w,
          vertical: 14.h,
        ),
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
                        ? AppColors.accentGoldLight
                        : AppColors.accentGoldDark,
                    fontSize: 11.sp,
                  ),
                ),
              ],
            ),
            10.ver,
            HojatyAiStatusPillWidget(stage: effectiveStage),
            if (text.isNotEmpty) ...[
              10.ver,
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
            ],
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

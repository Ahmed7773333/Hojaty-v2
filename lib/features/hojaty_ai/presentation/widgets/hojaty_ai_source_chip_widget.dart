import 'package:flutter/material.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/extensions/context_extensions.dart';
import '../../../../core/utils/screen_util_like.dart';
import '../../data/models/rag_chunk_model.dart';
import 'hojaty_ai_source_detail_sheet_widget.dart';

class HojatyAiSourceChipWidget extends StatelessWidget {
  final RagChunkModel source;

  const HojatyAiSourceChipWidget({
    super.key,
    required this.source,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final label = '${source.sourceTitle} • ${source.reference}';

    return Material(
      color: isDark ? AppColors.darkSurface : AppColors.lightCardSelected,
      borderRadius: BorderRadius.circular(12.r),
      child: InkWell(
        onTap: () {
          HojatyAiSourceDetailSheetWidget.show(context, source);
        },
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: isDark
                  ? AppColors.darkBorderSelected.withValues(alpha: 0.5)
                  : AppColors.primaryDark.withValues(alpha: 0.3),
              width: 1.0,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.menu_book_rounded,
                size: 14.r,
                color: isDark ? AppColors.accentGoldLight : AppColors.primaryDark,
              ),
              6.hor,
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 180.w),
                child: Text(
                  label,
                  style: context.textTheme.labelMedium?.copyWith(
                    color: isDark ? AppColors.darkTextPrimary : AppColors.primaryDark,
                    fontWeight: FontWeight.w700,
                    fontSize: 11.sp,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


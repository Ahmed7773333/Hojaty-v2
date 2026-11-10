import 'package:flutter/material.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/extensions/context_extensions.dart';
import '../../../../core/utils/screen_util_like.dart';
import '../../data/models/rag_chunk_model.dart';
import 'hojaty_ai_source_chip_widget.dart';

class HojatyAiSourcesSectionWidget extends StatelessWidget {
  final List<RagChunkModel> sources;

  const HojatyAiSourcesSectionWidget({
    super.key,
    required this.sources,
  });

  @override
  Widget build(BuildContext context) {
    if (sources.isEmpty) return const SizedBox.shrink();

    final isDark = context.isDark;

    return Padding(
      padding: EdgeInsets.only(top: 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.verified_rounded,
                size: 15.r,
                color: isDark ? AppColors.accentGoldLight : AppColors.accentGoldDark,
              ),
              6.hor,
              Text(
                context.strings.hojatyAiSourcesTitle,
                style: context.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  fontSize: 12.sp,
                  color: isDark ? AppColors.accentGoldLight : AppColors.accentGoldDark,
                ),
              ),
            ],
          ),
          8.ver,
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: sources.map((source) {
              return HojatyAiSourceChipWidget(source: source);
            }).toList(),
          ),
        ],
      ),
    );
  }
}


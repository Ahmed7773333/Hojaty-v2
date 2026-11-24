import 'package:material_ui/material_ui.dart';
import 'package:hojaty/core/utils/app_colors.dart';
import 'package:hojaty/core/utils/extensions/context_extensions.dart';
import 'package:hojaty/core/utils/screen_util_like.dart';
import 'package:hojaty/features/hojaty_ai/data/models/rag_chunk_model.dart';
import 'package:hojaty/features/hojaty_ai/presentation/widgets/hojaty_ai_source_chip_widget.dart';

class HojatyAiSourcesSectionWidget extends StatefulWidget {
  final List<RagChunkModel> sources;

  const HojatyAiSourcesSectionWidget({super.key, required this.sources});

  @override
  State<HojatyAiSourcesSectionWidget> createState() =>
      _HojatyAiSourcesSectionWidgetState();
}

class _HojatyAiSourcesSectionWidgetState
    extends State<HojatyAiSourcesSectionWidget> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    if (widget.sources.isEmpty) return const SizedBox.shrink();

    final isDark = context.isDark;
    final accentColor =
        isDark ? AppColors.accentGoldLight : AppColors.accentGoldDark;

    return Padding(
      padding: EdgeInsetsDirectional.only(top: 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            borderRadius: BorderRadius.circular(10.r),
            child: Padding(
              padding: EdgeInsetsDirectional.symmetric(
                horizontal: 4.w,
                vertical: 4.h,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.verified_rounded,
                    size: 15.r,
                    color: accentColor,
                  ),
                  6.hor,
                  Text(
                    context.strings.hojatyAiSourcesCount(widget.sources.length),
                    style: context.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      fontSize: 12.sp,
                      color: accentColor,
                    ),
                  ),
                  4.hor,
                  AnimatedRotation(
                    turns: _isExpanded ? 0.5 : 0.0,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 18.r,
                      color: accentColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Padding(
              padding: EdgeInsetsDirectional.only(top: 8.h),
              child: Wrap(
                spacing: 8.w,
                runSpacing: 8.h,
                children: List.generate(widget.sources.length, (index) {
                  return HojatyAiSourceChipWidget(
                    source: widget.sources[index],
                    footnoteIndex: index + 1,
                  );
                }),
              ),
            ),
            crossFadeState: _isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 200),
          ),
        ],
      ),
    );
  }
}

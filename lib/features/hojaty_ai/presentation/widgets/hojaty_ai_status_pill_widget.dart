import 'package:material_ui/material_ui.dart';
import 'package:hojaty/core/utils/app_colors.dart';
import 'package:hojaty/core/utils/extensions/context_extensions.dart';
import 'package:hojaty/core/utils/screen_util_like.dart';
import 'package:hojaty/features/hojaty_ai/presentation/bloc/hojaty_ai_state.dart';

class HojatyAiStatusPillWidget extends StatefulWidget {
  final HojatyAiProcessingStage stage;

  const HojatyAiStatusPillWidget({
    super.key,
    required this.stage,
  });

  @override
  State<HojatyAiStatusPillWidget> createState() =>
      _HojatyAiStatusPillWidgetState();
}

class _HojatyAiStatusPillWidgetState extends State<HojatyAiStatusPillWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _opacityAnimation = Tween<double>(begin: 0.45, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.stage == HojatyAiProcessingStage.idle) {
      return const SizedBox.shrink();
    }

    final isDark = context.isDark;
    final accentColor =
        isDark ? AppColors.accentGoldLight : AppColors.accentGoldDark;

    final IconData icon;
    final String label;
    switch (widget.stage) {
      case HojatyAiProcessingStage.searchingSources:
        icon = Icons.manage_search_rounded;
        label = context.strings.hojatyAiStageSearchingSources;
      case HojatyAiProcessingStage.executingTool:
        icon = Icons.bolt_rounded;
        label = context.strings.hojatyAiStageExecutingTool;
      case HojatyAiProcessingStage.generating:
        icon = Icons.auto_awesome_rounded;
        label = context.strings.hojatyAiStageGenerating;
      case HojatyAiProcessingStage.idle:
        return const SizedBox.shrink();
    }

    return FadeTransition(
      opacity: _opacityAnimation,
      child: Container(
        padding: EdgeInsetsDirectional.symmetric(
          horizontal: 10.w,
          vertical: 5.h,
        ),
        decoration: BoxDecoration(
          color: AppColors.accentGold.withValues(alpha: 0.14),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: AppColors.accentGold.withValues(alpha: 0.35),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14.r, color: accentColor),
            6.hor,
            Text(
              label,
              style: context.textTheme.labelSmall?.copyWith(
                color: accentColor,
                fontWeight: FontWeight.w700,
                fontSize: 11.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

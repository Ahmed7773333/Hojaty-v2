import 'package:material_ui/material_ui.dart';
import 'package:hojaty/core/utils/app_colors.dart';
import 'package:hojaty/core/utils/screen_util_like.dart';

class HighlightableSectionWidget extends StatefulWidget {
  final Widget child;
  final bool isHighlighted;
  final int highlightTrigger;
  final double borderRadius;

  const HighlightableSectionWidget({
    super.key,
    required this.child,
    required this.isHighlighted,
    this.highlightTrigger = 0,
    this.borderRadius = 16,
  });

  @override
  State<HighlightableSectionWidget> createState() =>
      _HighlightableSectionWidgetState();
}

class _HighlightableSectionWidgetState extends State<HighlightableSectionWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _pulseAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 0.0, end: 1.0)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 20,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 0.35)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 25,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 0.35, end: 0.9)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 25,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 0.9, end: 0.0)
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 30,
      ),
    ]).animate(_controller);

    if (widget.isHighlighted) {
      _controller.forward(from: 0);
    }
  }

  @override
  void didUpdateWidget(covariant HighlightableSectionWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isHighlighted &&
        (!oldWidget.isHighlighted ||
            widget.highlightTrigger != oldWidget.highlightTrigger)) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        final intensity = _pulseAnimation.value;
        if (intensity <= 0.001) {
          return child!;
        }
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius.r),
            boxShadow: [
              BoxShadow(
                color: AppColors.accentGold.withValues(alpha: 0.25 * intensity),
                blurRadius: 14 * intensity,
                spreadRadius: 2 * intensity,
              ),
            ],
          ),
          foregroundDecoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius.r),
            color: AppColors.accentGold.withValues(alpha: 0.10 * intensity),
            border: Border.all(
              color: AppColors.accentGold.withValues(alpha: 0.85 * intensity),
              width: 2,
            ),
          ),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

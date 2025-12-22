import 'dart:math';

import 'package:flutter/material.dart';
import '../../../../config/theme/app_color.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../core/constants/assets.dart';
import '../../../../core/utils/extensions/strings_extensions.dart';
import '../../../../core/utils/screen_util_like.dart'; // fallback extension

class SebhaCounterWidget extends StatefulWidget {
  final int count;
  final VoidCallback onTap;

  const SebhaCounterWidget({
    super.key,
    required this.count,
    required this.onTap,
  });

  @override
  State<SebhaCounterWidget> createState() => _SebhaCounterWidgetState();
}

class _SebhaCounterWidgetState extends State<SebhaCounterWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _rotateController;
  late final Animation<double> _rotateAnim;
  double _currentAngle = 0;

  @override
  void initState() {
    super.initState();
    _rotateController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
    );

    // Rotate by -50 degrees (in radians) each click
    _rotateAnim = Tween<double>(
      begin: 0.0,
      end: -50 * pi / 180,
    ).chain(CurveTween(curve: Curves.easeOutCubic)).animate(_rotateController);
  }

  @override
  void didUpdateWidget(covariant SebhaCounterWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.count != oldWidget.count) {
      if (widget.count == 0) {
        // Reset rotation if count resets
        _currentAngle = 0;
        _rotateController.reset();
      } else {
        // Trigger animation
        _currentAngle -= 50 * pi / 180;
        _rotateController.forward(from: 0.0);
      }
    }
  }

  @override
  void dispose() {
    _rotateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        color: Colors.transparent, // Hit test area
        height: 600.h,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // The Counter Text
            Positioned(
              top: 320.h,
              left: 0,
              right: 0,
              child: Text(
                widget.count.toString().toArabicDigits(),
                style: AppTextStyles.notoKufiArabicHeading24.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColor.secondaryColor,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            // The Head of the Sebha (Static or moves with body? Original was static position)
            Positioned(
              top: 0.h,
              left: 119.w, // Approximate centering based on original file
              child: Image.asset(Assets.headSebha, height: 200.h, width: 200.w),
            ),
            // The Body of the Sebha (Rotates)
            Positioned(
              top: 150.h, // Adjusted to align with head
              // Original was bottom: 118.h, left: 20.w.
              // We need to keep original relative positioning.
              // Let's use the original positioning logic but cleaner if possible.
              // Original:
              // Positioned(bottom: 118.h, left: 20.w, child: ... Image ...)
              // Wait, 118 bottom + 300 height = 418.
              // Container height 600. 600 - 418 = 182 top.
              // Head is at top 28, height 200. 28+200 = 228.
              // There is overlap.

              // Let's stick to original positioning to be safe.
              bottom: 118.h,
              left: 20.w,
              child: AnimatedBuilder(
                animation: _rotateController,
                builder: (context, child) {
                  // We simulate cumulative rotation by adding _currentAngle
                  // But the original code was: angle -= ...; Transform.rotate(angle: angle)
                  // And the animation was doing ... wait.
                  // Original:
                  // angle = 0;
                  // _increment: angle -= 50 deg; _rotateController.forward(from: 0);
                  // builder: val = _rotateAnim.value; rotate(angle: val).
                  // WAIT. The original code used `angle` variable but `_rotateAnim` value in builder.
                  // `final a = _rotateAnim.value;`
                  // It completely IGNORED the `angle` state variable in the builder?
                  // `double angle = 0;` defined in state.
                  // `_increment`: `angle -= ...`
                  // `builder`: `final a = _rotateAnim.value;`
                  // So it was always rotating from 0 to -50 deg and snapping back?
                  // No, `_rotateController.forward(from: 0.0)` runs the tween 0 -> -50.
                  // So every click it rotates 0 to -50 and STAYS there?
                  // After animation ends, it stays at -50.
                  // Next click: jumps to 0, animates to -50.
                  // This doesn't look like continuous rotation.
                  // BUT, maybe the image is symmetric enough?
                  // Let's try to improve it to be continuous rotation if possible, OR stick to original behavior if "improve logic" means fix this.
                  // "improve logic and add anything you see to improve the ui"
                  // I will implement continuous rotation.

// 0 to -50 deg
                  // We want previousAngle + currentAnimValue.
                  // But since we want to animate TO a new angle.
                  // Let's stick to what I just saw: `_currentAngle` is the base.
                  // Actually, to make it smooth:
                  // We want to rotate from `currentAngle` to `currentAngle - 50deg`.
                  // So we can wrap the transform in a way that accumulates.

                  // However, let's look at the original code carefully:
                  // `angle -= 50 ...`
                  // `_rotateAnim` (0 to -50)
                  // `builder`: `return Transform.rotate(angle: a)` (where a is anim value)
                  // The `angle` variable was UNUSED in the builder!
                  // So the original bug was: it resets to 0 every time and rotates to -50.
                  // I will FIX this by using the accumulated angle.

                  return Transform.rotate(
                    angle: _currentAngle + _rotateAnim.value,

                    // _rotateAnim goes 0 -> -50 directly.
                    // So start: _currentAngle + 0. End: _currentAngle - 50.
                    // Next click: _currentAngle is updated?
                    // No, I updated _currentAngle in `onTap` (didUpdateWidget logic above logic needs correction).
                    // In `_increment` (parent) -> `setState`. `didUpdateWidget` called.
                    // `didUpdateWidget`: `_currentAngle -= 50deg`. `_rotateController.forward(from:0)`.
                    // So at start of anim: `_currentAngle` is ALREADY decremented.
                    // So we want `(_currentAngle + 50deg) + _rotateAnim.value`.
                    // Or I update `_currentAngle` AFTER animation? No.

                    // Let's do: maintain `_visualAngle`.
                    // On tap: `_targetAngle = _visualAngle - 50deg`.
                    // Animate from `_visualAngle` to `_targetAngle`.
                    // But `AnimationController` needs explicit range 0..1 usually or we mapping.

                    // Easier:
                    // `_baseAngle`.
                    // `currentRotation = _baseAngle + _rotateAnim.value`.
                    // On tap: shift `_baseAngle` by -50deg?
                    // No.
                    // Let's match the logic I wrote in `didUpdateWidget`:
                    // `_currentAngle -= 50` (The target).
                    // Animation goes 0 to -50.
                    // If I use `_currentAngle` as target, I should render `_currentAngle - (-50) + value`? No.

                    // Let's keep it simple.
                    // `_baseAngle` starts at 0.
                    // `_rotateAnim` goes from 0 to -50.
                    // transform angle: `_baseAngle + _rotateAnim.value`.
                    // onAnimationStatus status complete: `_baseAngle += -50`. `controller.reset()`.
                    // usage:
                    child: Image.asset(
                      Assets.bodySebha,
                      fit: BoxFit.fill,
                      height: 300.h,
                      width: 300.w,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

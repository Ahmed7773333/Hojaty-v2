import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/extensions/context_extensions.dart';
import '../../../../core/utils/screen_util_like.dart';
import 'kaaba_icon_widget.dart';
import 'qibla_compass_painter.dart';

class QiblaCompassDialWidget extends StatelessWidget {
  final double heading;
  final double qiblaBearing;
  final bool isAligned;
  final bool hasSensor;

  const QiblaCompassDialWidget({
    super.key,
    required this.heading,
    required this.qiblaBearing,
    required this.isAligned,
    required this.hasSensor,
  });

  @override
  Widget build(BuildContext context) {
    final dialSize = 280.r;
    final isDark = context.isDark;

    // Angle of rotation in radians: negative heading rotates dial clockwise with phone
    final rotationRad = -heading * (math.pi / 180.0);

    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 1. Subtle glowing pulse aura when aligned with Kaaba
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: dialSize + 30.r,
            height: dialSize + 30.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: isAligned
                  ? [
                      BoxShadow(
                        color: AppColors.accentGold.withValues(alpha: 0.35),
                        blurRadius: 30,
                        spreadRadius: 8,
                      ),
                    ]
                  : null,
            ),
          ),

          // 2. Rotating compass dial (ticks, degree numbers, cardinal points, Kaaba mark)
          AnimatedRotation(
            turns: rotationRad / (2 * math.pi),
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOutCubic,
            child: SizedBox(
              width: dialSize,
              height: dialSize,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CustomPaint(
                    size: Size(dialSize, dialSize),
                    painter: QiblaCompassPainter(
                      qiblaBearing: qiblaBearing,
                      isAligned: isAligned,
                      isDark: isDark,
                      northLabel: context.strings.qiblaNorth,
                      eastLabel: context.strings.qiblaEast,
                      southLabel: context.strings.qiblaSouth,
                      westLabel: context.strings.qiblaWest,
                    ),
                  ),

                  // Kaaba icon situated right on the perimeter at qiblaBearing angle
                  Transform.rotate(
                    angle: qiblaBearing * (math.pi / 180.0) - (math.pi / 2),
                    child: Transform.translate(
                      offset: Offset(dialSize / 2 - 20.r, 0),
                      child: Transform.rotate(
                        angle: math.pi / 2,
                        child: const KaabaIconWidget(size: 26),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 3. Fixed Line of Sight Indicator (12 o'clock top arrow on the phone)
          Positioned(
            top: 2.h,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: isAligned ? AppColors.accentGold : AppColors.primaryDarkBackground,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: AppColors.accentGold,
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.black.withValues(alpha: 0.2),
                    blurRadius: 6,
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.navigation_rounded,
                    color: isAligned ? AppColors.white : AppColors.accentGoldLight,
                    size: 14.r,
                  ),
                  4.hor,
                  Text(
                    '${heading.round()}°',
                    style: context.textTheme.labelSmall?.copyWith(
                      color: isAligned ? AppColors.white : AppColors.accentGoldLight,
                      fontWeight: FontWeight.w800,
                      fontSize: 11.sp,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 4. Center hub / golden pointer
          Container(
            width: 44.r,
            height: 44.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isDark ? AppColors.primaryDarkBackground : AppColors.lightSurface,
              border: Border.all(
                color: isAligned ? AppColors.accentGold : AppColors.primaryDarkBorder,
                width: 2.0,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.black.withValues(alpha: 0.15),
                  blurRadius: 8,
                ),
              ],
            ),
            child: Center(
              child: Icon(
                Icons.adjust_rounded,
                color: isAligned ? AppColors.accentGold : AppColors.darkTextSecondary,
                size: 20.r,
              ),
            ),
          ),
        ],
      ),
    );
  }
}


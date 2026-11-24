import 'package:material_ui/material_ui.dart';
import 'package:hojaty/config/theme/app_theme_mode.dart';
import 'package:hojaty/config/theme/liquid_glass_surface_variant.dart';
import 'package:hojaty/core/utils/app_colors.dart';

class LiquidGlassStyle {
  static const double minBlurSigma = 14.0;
  static const double defaultBlurSigma = 18.0;
  static const double maxBlurSigma = 24.0;

  /// Rec. 709 luminance-preserving 1.45x vibrancy boost for Light & Dark glass.
  static const ColorFilter vibrantSaturationFilter = ColorFilter.matrix(<double>[
    1.3543, -0.3218, -0.0325, 0, 0,
    -0.0957, 1.1282, -0.0325, 0, 0,
    -0.0957, -0.3218, 1.4175, 0, 0,
    0, 0, 0, 1, 0,
  ]);

  /// Subtle 1.25x Rec. 709 vibrancy boost calibrated for pitch-black AMOLED.
  static const ColorFilter amoledSaturationFilter = ColorFilter.matrix(<double>[
    1.1969, -0.1788, -0.0181, 0, 0,
    -0.0532, 1.0712, -0.0181, 0, 0,
    -0.0532, -0.1788, 1.2320, 0, 0,
    0, 0, 0, 1, 0,
  ]);

  final Color tintColor;
  final List<Color> sheenColors;
  final Color innerHighlightColor;
  final Color innerShadowColor;
  final List<Color> borderGradientColors;
  final double borderWidth;
  final Color shadowColor;
  final double shadowBlurRadius;
  final Offset shadowOffset;
  final double defaultSigma;
  final ColorFilter saturationFilter;

  const LiquidGlassStyle({
    required this.tintColor,
    required this.sheenColors,
    required this.innerHighlightColor,
    required this.innerShadowColor,
    required this.borderGradientColors,
    required this.shadowColor,
    required this.shadowBlurRadius,
    required this.shadowOffset,
    this.borderWidth = 1.2,
    this.defaultSigma = defaultBlurSigma,
    this.saturationFilter = vibrantSaturationFilter,
  });

  static double clampSigma(double sigma) =>
      sigma.clamp(minBlurSigma, maxBlurSigma);

  static LiquidGlassStyle resolve(
    AppThemeMode mode, {
    LiquidGlassSurfaceVariant variant = LiquidGlassSurfaceVariant.surface,
  }) {
    switch (variant) {
      case LiquidGlassSurfaceVariant.surface:
        return switch (mode) {
          AppThemeMode.light => LiquidGlassStyle(
            tintColor: AppColors.white.withValues(alpha: 0.62),
            sheenColors: [
              AppColors.white.withValues(alpha: 0.44),
              AppColors.white.withValues(alpha: 0.04),
              AppColors.accentGoldExtraLight.withValues(alpha: 0.14),
            ],
            innerHighlightColor: AppColors.white.withValues(alpha: 0.72),
            innerShadowColor: AppColors.primaryDark.withValues(alpha: 0.06),
            borderGradientColors: [
              AppColors.white.withValues(alpha: 0.92),
              AppColors.primaryDark.withValues(alpha: 0.10),
              AppColors.white.withValues(alpha: 0.58),
            ],
            shadowColor: AppColors.primaryDark.withValues(alpha: 0.10),
            shadowBlurRadius: 24.0,
            shadowOffset: const Offset(0, 10),
            defaultSigma: 20.0,
          ),
          AppThemeMode.dark => LiquidGlassStyle(
            tintColor: AppColors.greenDarkSurface.withValues(alpha: 0.56),
            sheenColors: [
              AppColors.white.withValues(alpha: 0.18),
              AppColors.white.withValues(alpha: 0.02),
              AppColors.accentGoldLight.withValues(alpha: 0.07),
            ],
            innerHighlightColor: AppColors.white.withValues(alpha: 0.28),
            innerShadowColor: AppColors.black.withValues(alpha: 0.28),
            borderGradientColors: [
              AppColors.white.withValues(alpha: 0.44),
              AppColors.white.withValues(alpha: 0.06),
              AppColors.accentGoldLight.withValues(alpha: 0.28),
            ],
            shadowColor: AppColors.black.withValues(alpha: 0.30),
            shadowBlurRadius: 26.0,
            shadowOffset: const Offset(0, 10),
            defaultSigma: 20.0,
          ),
          AppThemeMode.amoled => LiquidGlassStyle(
            tintColor: AppColors.amoledCardSelected.withValues(alpha: 0.62),
            sheenColors: [
              AppColors.white.withValues(alpha: 0.14),
              AppColors.white.withValues(alpha: 0.01),
              AppColors.accentGold.withValues(alpha: 0.06),
            ],
            innerHighlightColor: AppColors.white.withValues(alpha: 0.22),
            innerShadowColor: AppColors.black.withValues(alpha: 0.45),
            borderGradientColors: [
              AppColors.white.withValues(alpha: 0.38),
              AppColors.white.withValues(alpha: 0.05),
              AppColors.accentGold.withValues(alpha: 0.26),
            ],
            shadowColor: AppColors.black.withValues(alpha: 0.50),
            shadowBlurRadius: 26.0,
            shadowOffset: const Offset(0, 10),
            defaultSigma: 20.0,
            saturationFilter: amoledSaturationFilter,
          ),
        };

      case LiquidGlassSurfaceVariant.card:
        return switch (mode) {
          AppThemeMode.light => LiquidGlassStyle(
            tintColor: AppColors.white.withValues(alpha: 0.56),
            sheenColors: [
              AppColors.white.withValues(alpha: 0.40),
              AppColors.white.withValues(alpha: 0.03),
              AppColors.accentGoldExtraLight.withValues(alpha: 0.12),
            ],
            innerHighlightColor: AppColors.white.withValues(alpha: 0.68),
            innerShadowColor: AppColors.primaryDark.withValues(alpha: 0.05),
            borderGradientColors: [
              AppColors.white.withValues(alpha: 0.88),
              AppColors.primaryDark.withValues(alpha: 0.09),
              AppColors.accentGold.withValues(alpha: 0.26),
            ],
            shadowColor: AppColors.primaryDark.withValues(alpha: 0.07),
            shadowBlurRadius: 20.0,
            shadowOffset: const Offset(0, 8),
            defaultSigma: 18.0,
          ),
          AppThemeMode.dark => LiquidGlassStyle(
            tintColor: AppColors.greenDarkCardUnselected.withValues(
              alpha: 0.52,
            ),
            sheenColors: [
              AppColors.white.withValues(alpha: 0.15),
              AppColors.white.withValues(alpha: 0.02),
              AppColors.accentGoldLight.withValues(alpha: 0.06),
            ],
            innerHighlightColor: AppColors.white.withValues(alpha: 0.24),
            innerShadowColor: AppColors.black.withValues(alpha: 0.25),
            borderGradientColors: [
              AppColors.white.withValues(alpha: 0.36),
              AppColors.greenDarkBorderUnselected.withValues(alpha: 0.16),
              AppColors.accentGoldLight.withValues(alpha: 0.24),
            ],
            shadowColor: AppColors.black.withValues(alpha: 0.22),
            shadowBlurRadius: 20.0,
            shadowOffset: const Offset(0, 8),
            defaultSigma: 18.0,
          ),
          AppThemeMode.amoled => LiquidGlassStyle(
            tintColor: AppColors.amoledCardSelected.withValues(alpha: 0.58),
            sheenColors: [
              AppColors.white.withValues(alpha: 0.12),
              AppColors.white.withValues(alpha: 0.01),
              AppColors.accentGold.withValues(alpha: 0.05),
            ],
            innerHighlightColor: AppColors.white.withValues(alpha: 0.18),
            innerShadowColor: AppColors.black.withValues(alpha: 0.42),
            borderGradientColors: [
              AppColors.white.withValues(alpha: 0.30),
              AppColors.amoledBorderUnselected.withValues(alpha: 0.22),
              AppColors.accentGold.withValues(alpha: 0.22),
            ],
            shadowColor: AppColors.black.withValues(alpha: 0.42),
            shadowBlurRadius: 20.0,
            shadowOffset: const Offset(0, 8),
            defaultSigma: 18.0,
            saturationFilter: amoledSaturationFilter,
          ),
        };

      case LiquidGlassSurfaceVariant.brandHeader:
        return switch (mode) {
          AppThemeMode.light => LiquidGlassStyle(
            tintColor: AppColors.primaryDarkHeader.withValues(alpha: 0.90),
            sheenColors: [
              AppColors.white.withValues(alpha: 0.16),
              AppColors.primaryDarkSurface.withValues(alpha: 0.10),
              AppColors.accentGold.withValues(alpha: 0.08),
            ],
            innerHighlightColor: AppColors.white.withValues(alpha: 0.22),
            innerShadowColor: AppColors.black.withValues(alpha: 0.22),
            borderGradientColors: [
              AppColors.white.withValues(alpha: 0.32),
              AppColors.accentGoldLight.withValues(alpha: 0.30),
              AppColors.primaryDarkBorder.withValues(alpha: 0.55),
            ],
            shadowColor: AppColors.primaryDarkHeader.withValues(alpha: 0.20),
            shadowBlurRadius: 18.0,
            shadowOffset: const Offset(0, 6),
            defaultSigma: 18.0,
          ),
          AppThemeMode.dark => LiquidGlassStyle(
            tintColor: AppColors.primaryDarkHeader.withValues(alpha: 0.76),
            sheenColors: [
              AppColors.white.withValues(alpha: 0.14),
              AppColors.primaryDarkSurface.withValues(alpha: 0.06),
              AppColors.accentGold.withValues(alpha: 0.07),
            ],
            innerHighlightColor: AppColors.white.withValues(alpha: 0.20),
            innerShadowColor: AppColors.black.withValues(alpha: 0.28),
            borderGradientColors: [
              AppColors.white.withValues(alpha: 0.28),
              AppColors.accentGoldLight.withValues(alpha: 0.24),
              AppColors.primaryDarkBorder.withValues(alpha: 0.45),
            ],
            shadowColor: AppColors.black.withValues(alpha: 0.26),
            shadowBlurRadius: 18.0,
            shadowOffset: const Offset(0, 6),
            defaultSigma: 18.0,
          ),
          AppThemeMode.amoled => LiquidGlassStyle(
            tintColor: AppColors.amoledSurface.withValues(alpha: 0.80),
            sheenColors: [
              AppColors.white.withValues(alpha: 0.12),
              AppColors.amoledCardSelected.withValues(alpha: 0.06),
              AppColors.accentGold.withValues(alpha: 0.06),
            ],
            innerHighlightColor: AppColors.white.withValues(alpha: 0.18),
            innerShadowColor: AppColors.black.withValues(alpha: 0.45),
            borderGradientColors: [
              AppColors.white.withValues(alpha: 0.26),
              AppColors.accentGold.withValues(alpha: 0.22),
              AppColors.amoledBorderUnselected.withValues(alpha: 0.45),
            ],
            shadowColor: AppColors.black.withValues(alpha: 0.45),
            shadowBlurRadius: 18.0,
            shadowOffset: const Offset(0, 6),
            defaultSigma: 18.0,
            saturationFilter: amoledSaturationFilter,
          ),
        };

      case LiquidGlassSurfaceVariant.brandCard:
        return switch (mode) {
          AppThemeMode.light => LiquidGlassStyle(
            tintColor: AppColors.primaryDark.withValues(alpha: 0.86),
            sheenColors: [
              AppColors.white.withValues(alpha: 0.22),
              AppColors.primaryDarkSurface.withValues(alpha: 0.08),
              AppColors.accentGoldLight.withValues(alpha: 0.12),
            ],
            innerHighlightColor: AppColors.white.withValues(alpha: 0.34),
            innerShadowColor: AppColors.black.withValues(alpha: 0.24),
            borderGradientColors: [
              AppColors.white.withValues(alpha: 0.50),
              AppColors.primaryDarkBorder.withValues(alpha: 0.25),
              AppColors.accentGoldLight.withValues(alpha: 0.42),
            ],
            shadowColor: AppColors.primaryDark.withValues(alpha: 0.24),
            shadowBlurRadius: 24.0,
            shadowOffset: const Offset(0, 10),
            defaultSigma: 18.0,
          ),
          AppThemeMode.dark => LiquidGlassStyle(
            tintColor: AppColors.primaryDark.withValues(alpha: 0.72),
            sheenColors: [
              AppColors.white.withValues(alpha: 0.18),
              AppColors.primaryDarkSurface.withValues(alpha: 0.05),
              AppColors.accentGoldLight.withValues(alpha: 0.10),
            ],
            innerHighlightColor: AppColors.white.withValues(alpha: 0.28),
            innerShadowColor: AppColors.black.withValues(alpha: 0.30),
            borderGradientColors: [
              AppColors.white.withValues(alpha: 0.40),
              AppColors.primaryDarkBorder.withValues(alpha: 0.20),
              AppColors.accentGoldLight.withValues(alpha: 0.36),
            ],
            shadowColor: AppColors.black.withValues(alpha: 0.28),
            shadowBlurRadius: 24.0,
            shadowOffset: const Offset(0, 10),
            defaultSigma: 18.0,
          ),
          AppThemeMode.amoled => LiquidGlassStyle(
            tintColor: AppColors.amoledCardSelected.withValues(alpha: 0.76),
            sheenColors: [
              AppColors.white.withValues(alpha: 0.15),
              AppColors.white.withValues(alpha: 0.02),
              AppColors.accentGold.withValues(alpha: 0.08),
            ],
            innerHighlightColor: AppColors.white.withValues(alpha: 0.24),
            innerShadowColor: AppColors.black.withValues(alpha: 0.48),
            borderGradientColors: [
              AppColors.white.withValues(alpha: 0.36),
              AppColors.amoledBorderUnselected.withValues(alpha: 0.22),
              AppColors.accentGold.withValues(alpha: 0.34),
            ],
            shadowColor: AppColors.black.withValues(alpha: 0.48),
            shadowBlurRadius: 24.0,
            shadowOffset: const Offset(0, 10),
            defaultSigma: 18.0,
            saturationFilter: amoledSaturationFilter,
          ),
        };

      case LiquidGlassSurfaceVariant.floatingCard:
        return switch (mode) {
          AppThemeMode.light || AppThemeMode.dark => LiquidGlassStyle(
            tintColor: AppColors.white.withValues(alpha: 0.12),
            sheenColors: [
              AppColors.white.withValues(alpha: 0.26),
              AppColors.white.withValues(alpha: 0.02),
              AppColors.accentGoldLight.withValues(alpha: 0.10),
            ],
            innerHighlightColor: AppColors.white.withValues(alpha: 0.38),
            innerShadowColor: AppColors.black.withValues(alpha: 0.22),
            borderGradientColors: [
              AppColors.white.withValues(alpha: 0.52),
              AppColors.white.withValues(alpha: 0.08),
              AppColors.accentGoldLight.withValues(alpha: 0.36),
            ],
            shadowColor: AppColors.black.withValues(alpha: 0.20),
            shadowBlurRadius: 22.0,
            shadowOffset: const Offset(0, 8),
            defaultSigma: 18.0,
          ),
          AppThemeMode.amoled => LiquidGlassStyle(
            tintColor: AppColors.amoledCardSelected.withValues(alpha: 0.64),
            sheenColors: [
              AppColors.white.withValues(alpha: 0.16),
              AppColors.white.withValues(alpha: 0.02),
              AppColors.accentGold.withValues(alpha: 0.08),
            ],
            innerHighlightColor: AppColors.white.withValues(alpha: 0.24),
            innerShadowColor: AppColors.black.withValues(alpha: 0.45),
            borderGradientColors: [
              AppColors.white.withValues(alpha: 0.38),
              AppColors.white.withValues(alpha: 0.06),
              AppColors.accentGold.withValues(alpha: 0.32),
            ],
            shadowColor: AppColors.black.withValues(alpha: 0.44),
            shadowBlurRadius: 22.0,
            shadowOffset: const Offset(0, 8),
            defaultSigma: 18.0,
            saturationFilter: amoledSaturationFilter,
          ),
        };
    }
  }
}

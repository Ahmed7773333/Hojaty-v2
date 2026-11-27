import 'package:material_ui/material_ui.dart';
import 'package:hojaty/config/theme/app_theme_mode.dart';
import 'package:hojaty/config/theme/liquid_glass_surface_variant.dart';
import 'package:hojaty/core/utils/app_colors.dart';

class LiquidGlassStyle {
  static const double minBlurSigma = 6.0;
  static const double defaultBlurSigma = 10.0;
  static const double maxBlurSigma = 14.0;

  final Color tintColor;
  final List<Color> borderGradientColors;
  final double borderWidth;
  final Color shadowColor;
  final double shadowBlurRadius;
  final Offset shadowOffset;

  const LiquidGlassStyle({
    required this.tintColor,
    required this.borderGradientColors,
    required this.shadowColor,
    required this.shadowBlurRadius,
    required this.shadowOffset,
    this.borderWidth = 1.1,
  });

  static double clampSigma(double sigma) =>
      sigma.clamp(minBlurSigma, maxBlurSigma);

  static final Map<(AppThemeMode, LiquidGlassSurfaceVariant), LiquidGlassStyle>
  _cache = <(AppThemeMode, LiquidGlassSurfaceVariant), LiquidGlassStyle>{};

  static LiquidGlassStyle resolve(
    AppThemeMode mode, {
    LiquidGlassSurfaceVariant variant = LiquidGlassSurfaceVariant.surface,
  }) {
    return _cache.putIfAbsent((mode, variant), () => _create(mode, variant));
  }

  static LiquidGlassStyle _create(
    AppThemeMode mode,
    LiquidGlassSurfaceVariant variant,
  ) {
    switch (variant) {
      case LiquidGlassSurfaceVariant.surface:
        return switch (mode) {
          AppThemeMode.light => LiquidGlassStyle(
            tintColor: AppColors.white.withValues(alpha: 0.66),
            borderGradientColors: [
              AppColors.white.withValues(alpha: 0.92),
              AppColors.primaryDark.withValues(alpha: 0.12),
              AppColors.white.withValues(alpha: 0.60),
            ],
            shadowColor: AppColors.primaryDark.withValues(alpha: 0.09),
            shadowBlurRadius: 14.0,
            shadowOffset: const Offset(0, 6),
          ),
          AppThemeMode.dark => LiquidGlassStyle(
            tintColor: AppColors.greenDarkSurface.withValues(alpha: 0.60),
            borderGradientColors: [
              AppColors.white.withValues(alpha: 0.44),
              AppColors.white.withValues(alpha: 0.07),
              AppColors.accentGoldLight.withValues(alpha: 0.28),
            ],
            shadowColor: AppColors.black.withValues(alpha: 0.26),
            shadowBlurRadius: 14.0,
            shadowOffset: const Offset(0, 6),
          ),
          AppThemeMode.amoled => LiquidGlassStyle(
            tintColor: AppColors.amoledCardSelected.withValues(alpha: 0.68),
            borderGradientColors: [
              AppColors.white.withValues(alpha: 0.36),
              AppColors.white.withValues(alpha: 0.06),
              AppColors.accentGold.withValues(alpha: 0.26),
            ],
            shadowColor: AppColors.black.withValues(alpha: 0.40),
            shadowBlurRadius: 14.0,
            shadowOffset: const Offset(0, 6),
          ),
        };

      case LiquidGlassSurfaceVariant.card:
        return switch (mode) {
          AppThemeMode.light => LiquidGlassStyle(
            tintColor: AppColors.white.withValues(alpha: 0.60),
            borderGradientColors: [
              AppColors.white.withValues(alpha: 0.88),
              AppColors.primaryDark.withValues(alpha: 0.09),
              AppColors.accentGold.withValues(alpha: 0.26),
            ],
            shadowColor: AppColors.primaryDark.withValues(alpha: 0.06),
            shadowBlurRadius: 12.0,
            shadowOffset: const Offset(0, 4),
          ),
          AppThemeMode.dark => LiquidGlassStyle(
            tintColor: AppColors.greenDarkCardUnselected.withValues(
              alpha: 0.56,
            ),
            borderGradientColors: [
              AppColors.white.withValues(alpha: 0.36),
              AppColors.greenDarkBorderUnselected.withValues(alpha: 0.18),
              AppColors.accentGoldLight.withValues(alpha: 0.24),
            ],
            shadowColor: AppColors.black.withValues(alpha: 0.20),
            shadowBlurRadius: 12.0,
            shadowOffset: const Offset(0, 4),
          ),
          AppThemeMode.amoled => LiquidGlassStyle(
            tintColor: AppColors.amoledCardSelected.withValues(alpha: 0.62),
            borderGradientColors: [
              AppColors.white.withValues(alpha: 0.30),
              AppColors.amoledBorderUnselected.withValues(alpha: 0.24),
              AppColors.accentGold.withValues(alpha: 0.22),
            ],
            shadowColor: AppColors.black.withValues(alpha: 0.35),
            shadowBlurRadius: 12.0,
            shadowOffset: const Offset(0, 4),
          ),
        };

      case LiquidGlassSurfaceVariant.brandHeader:
        return switch (mode) {
          AppThemeMode.light => LiquidGlassStyle(
            tintColor: AppColors.primaryDarkHeader.withValues(alpha: 0.88),
            borderGradientColors: [
              AppColors.white.withValues(alpha: 0.32),
              AppColors.accentGoldLight.withValues(alpha: 0.30),
              AppColors.primaryDarkBorder.withValues(alpha: 0.55),
            ],
            shadowColor: AppColors.primaryDarkHeader.withValues(alpha: 0.16),
            shadowBlurRadius: 10.0,
            shadowOffset: const Offset(0, 4),
          ),
          AppThemeMode.dark => LiquidGlassStyle(
            tintColor: AppColors.primaryDarkHeader.withValues(alpha: 0.76),
            borderGradientColors: [
              AppColors.white.withValues(alpha: 0.28),
              AppColors.accentGoldLight.withValues(alpha: 0.24),
              AppColors.primaryDarkBorder.withValues(alpha: 0.45),
            ],
            shadowColor: AppColors.black.withValues(alpha: 0.22),
            shadowBlurRadius: 10.0,
            shadowOffset: const Offset(0, 4),
          ),
          AppThemeMode.amoled => LiquidGlassStyle(
            tintColor: AppColors.amoledSurface.withValues(alpha: 0.82),
            borderGradientColors: [
              AppColors.white.withValues(alpha: 0.26),
              AppColors.accentGold.withValues(alpha: 0.22),
              AppColors.amoledBorderUnselected.withValues(alpha: 0.45),
            ],
            shadowColor: AppColors.black.withValues(alpha: 0.36),
            shadowBlurRadius: 10.0,
            shadowOffset: const Offset(0, 4),
          ),
        };

      case LiquidGlassSurfaceVariant.brandCard:
        return switch (mode) {
          AppThemeMode.light => LiquidGlassStyle(
            tintColor: AppColors.primaryDark.withValues(alpha: 0.84),
            borderGradientColors: [
              AppColors.white.withValues(alpha: 0.50),
              AppColors.primaryDarkBorder.withValues(alpha: 0.25),
              AppColors.accentGoldLight.withValues(alpha: 0.42),
            ],
            shadowColor: AppColors.primaryDark.withValues(alpha: 0.20),
            shadowBlurRadius: 14.0,
            shadowOffset: const Offset(0, 6),
          ),
          AppThemeMode.dark => LiquidGlassStyle(
            tintColor: AppColors.primaryDark.withValues(alpha: 0.72),
            borderGradientColors: [
              AppColors.white.withValues(alpha: 0.40),
              AppColors.primaryDarkBorder.withValues(alpha: 0.20),
              AppColors.accentGoldLight.withValues(alpha: 0.36),
            ],
            shadowColor: AppColors.black.withValues(alpha: 0.24),
            shadowBlurRadius: 14.0,
            shadowOffset: const Offset(0, 6),
          ),
          AppThemeMode.amoled => LiquidGlassStyle(
            tintColor: AppColors.amoledCardSelected.withValues(alpha: 0.76),
            borderGradientColors: [
              AppColors.white.withValues(alpha: 0.36),
              AppColors.amoledBorderUnselected.withValues(alpha: 0.22),
              AppColors.accentGold.withValues(alpha: 0.34),
            ],
            shadowColor: AppColors.black.withValues(alpha: 0.38),
            shadowBlurRadius: 14.0,
            shadowOffset: const Offset(0, 6),
          ),
        };

      case LiquidGlassSurfaceVariant.floatingCard:
        return switch (mode) {
          AppThemeMode.light || AppThemeMode.dark => LiquidGlassStyle(
            tintColor: AppColors.white.withValues(alpha: 0.14),
            borderGradientColors: [
              AppColors.white.withValues(alpha: 0.52),
              AppColors.white.withValues(alpha: 0.08),
              AppColors.accentGoldLight.withValues(alpha: 0.36),
            ],
            shadowColor: AppColors.black.withValues(alpha: 0.18),
            shadowBlurRadius: 12.0,
            shadowOffset: const Offset(0, 5),
          ),
          AppThemeMode.amoled => LiquidGlassStyle(
            tintColor: AppColors.amoledCardSelected.withValues(alpha: 0.64),
            borderGradientColors: [
              AppColors.white.withValues(alpha: 0.38),
              AppColors.white.withValues(alpha: 0.06),
              AppColors.accentGold.withValues(alpha: 0.32),
            ],
            shadowColor: AppColors.black.withValues(alpha: 0.36),
            shadowBlurRadius: 12.0,
            shadowOffset: const Offset(0, 5),
          ),
        };
    }
  }
}

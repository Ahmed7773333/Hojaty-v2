import 'package:material_ui/material_ui.dart';
import 'package:hojaty/config/theme/app_theme_mode.dart';
import 'package:hojaty/core/utils/app_colors.dart';
import 'package:hojaty/core/utils/extensions/context_extensions.dart';

/// Zero-animation static ambient light pools behind pages when Liquid Glass is active,
/// giving translucent cards real optical depth and color refraction as they scroll.
class LiquidGlassBackdrop extends StatelessWidget {
  final Widget child;

  const LiquidGlassBackdrop({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    if (!context.isLiquidGlassEnabled) {
      return child;
    }

    final mode = context.appThemeMode;
    final (
      Color baseBg,
      Color topOrb,
      Color midOrb,
      Color bottomOrb,
    ) = switch (mode) {
      AppThemeMode.light => (
        AppColors.lightBackground,
        AppColors.accentGoldLight.withValues(alpha: 0.22),
        AppColors.primaryDark.withValues(alpha: 0.12),
        AppColors.accentGold.withValues(alpha: 0.16),
      ),
      AppThemeMode.dark => (
        AppColors.greenDarkBackground,
        AppColors.accentGold.withValues(alpha: 0.18),
        AppColors.greenDarkCardSelected.withValues(alpha: 0.45),
        AppColors.accentGoldLight.withValues(alpha: 0.14),
      ),
      AppThemeMode.amoled => (
        AppColors.amoledBackground,
        AppColors.accentGold.withValues(alpha: 0.10),
        AppColors.primaryDarkSurface.withValues(alpha: 0.18),
        AppColors.accentGoldDark.withValues(alpha: 0.08),
      ),
    };

    return Stack(
      fit: StackFit.expand,
      children: [
        RepaintBoundary(
          child: IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(color: baseBg),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        center: const Alignment(0.85, -0.55),
                        radius: 0.95,
                        colors: [topOrb, AppColors.transparent],
                      ),
                    ),
                  ),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        center: const Alignment(-0.90, 0.15),
                        radius: 1.05,
                        colors: [midOrb, AppColors.transparent],
                      ),
                    ),
                  ),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        center: const Alignment(0.75, 0.85),
                        radius: 0.95,
                        colors: [bottomOrb, AppColors.transparent],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        child,
      ],
    );
  }
}


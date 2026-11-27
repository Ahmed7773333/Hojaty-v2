import 'package:material_ui/material_ui.dart';
import 'package:hojaty/config/theme/app_theme_mode.dart';
import 'package:hojaty/core/utils/app_colors.dart';
import 'package:hojaty/core/utils/extensions/context_extensions.dart';
import 'package:hojaty/core/widgets/liquid_glass_ambient_painter.dart';

/// Establishes a shared [BackdropGroup] and raster-cached static ambient light
/// pools behind pages when Liquid Glass is active, eliminating per-card
/// framebuffer copies and full-screen gradient overdraw.
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

    return BackdropGroup(
      child: Stack(
        fit: StackFit.expand,
        children: [
          RepaintBoundary(
            child: IgnorePointer(
              child: CustomPaint(
                painter: LiquidGlassAmbientPainter(
                  baseColor: baseBg,
                  topOrbColor: topOrb,
                  midOrbColor: midOrb,
                  bottomOrbColor: bottomOrb,
                ),
                child: const SizedBox.expand(),
              ),
            ),
          ),
          child,
        ],
      ),
    );
  }
}

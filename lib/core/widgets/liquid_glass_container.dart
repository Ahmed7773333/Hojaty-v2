import 'dart:ui' as ui;

import 'package:material_ui/material_ui.dart';
import 'package:hojaty/config/theme/liquid_glass_border_edges.dart';
import 'package:hojaty/config/theme/liquid_glass_style.dart';
import 'package:hojaty/config/theme/liquid_glass_surface_variant.dart';
import 'package:hojaty/core/utils/extensions/context_extensions.dart';
import 'package:hojaty/core/widgets/liquid_glass_border_painter.dart';

/// Liquid Glass surface: frosted backdrop + theme tint + specular rim.
///
/// Uses [BackdropFilter.grouped] with a shared, value-equal blur so that every
/// glass card under the same [BackdropGroup] shares one backdrop capture and
/// the engine collapses identical blurs into a single pass. Zero overhead when
/// Liquid Glass is disabled.
class LiquidGlassContainer extends StatelessWidget {
  static final Map<double, ui.ImageFilter> _blurCache =
      <double, ui.ImageFilter>{};

  final Widget child;
  final double? width;
  final double? height;
  final BoxConstraints? constraints;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? borderRadius;
  final double? blurSigma;
  final LiquidGlassSurfaceVariant variant;
  final LiquidGlassBorderEdges borderEdges;
  final Color? customTintColor;
  final Color? customBorderColor;
  final double? customBorderWidth;
  final Color? fallbackColor;
  final BoxDecoration? fallbackDecoration;
  final bool showShadow;
  final bool? enabled;

  const LiquidGlassContainer({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.constraints,
    this.padding,
    this.margin,
    this.borderRadius,
    this.blurSigma,
    this.variant = LiquidGlassSurfaceVariant.surface,
    this.borderEdges = LiquidGlassBorderEdges.all,
    this.customTintColor,
    this.customBorderColor,
    this.customBorderWidth,
    this.fallbackColor,
    this.fallbackDecoration,
    this.showShadow = true,
    this.enabled,
  });

  static ui.ImageFilter _blur(double sigma) => _blurCache.putIfAbsent(
    sigma,
    () => ui.ImageFilter.blur(
      sigmaX: sigma,
      sigmaY: sigma,
      tileMode: TileMode.clamp,
    ),
  );

  @override
  Widget build(BuildContext context) {
    final isEnabled = enabled ?? context.isLiquidGlassEnabled;

    if (!isEnabled) {
      return Container(
        width: width,
        height: height,
        constraints: constraints,
        margin: margin,
        padding: padding,
        color: fallbackDecoration == null ? fallbackColor : null,
        decoration: fallbackDecoration,
        child: child,
      );
    }

    final style = context.liquidGlassStyle(variant);
    final sigma = LiquidGlassStyle.clampSigma(
      blurSigma ?? LiquidGlassStyle.defaultBlurSigma,
    );
    final effectiveRadius = borderRadius ?? BorderRadius.zero;
    final effectiveRimColors = customBorderColor != null
        ? <Color>[
            customBorderColor!.withValues(alpha: 0.90),
            customBorderColor!.withValues(alpha: 0.35),
            customBorderColor!.withValues(alpha: 0.72),
          ]
        : style.borderGradientColors;

    final glassBody = BackdropFilter.grouped(
      filter: _blur(sigma),
      child: CustomPaint(
        foregroundPainter: LiquidGlassBorderPainter(
          borderRadius: effectiveRadius,
          gradientColors: effectiveRimColors,
          strokeWidth: customBorderWidth ?? style.borderWidth,
          edges: borderEdges,
        ),
        child: ColoredBox(
          color: customTintColor ?? style.tintColor,
          child: Padding(padding: padding ?? EdgeInsets.zero, child: child),
        ),
      ),
    );

    final clipped = borderRadius != null
        ? ClipRRect(borderRadius: effectiveRadius, child: glassBody)
        : ClipRect(child: glassBody);

    final hasShadow = showShadow && borderRadius != null;

    return Container(
      width: width,
      height: height,
      constraints: constraints,
      margin: margin,
      decoration: hasShadow
          ? BoxDecoration(
              borderRadius: borderRadius,
              boxShadow: [
                BoxShadow(
                  color: style.shadowColor,
                  blurRadius: style.shadowBlurRadius,
                  offset: style.shadowOffset,
                ),
              ],
            )
          : null,
      child: clipped,
    );
  }
}

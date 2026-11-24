import 'dart:ui' show ImageFilter;

import 'package:material_ui/material_ui.dart';
import 'package:hojaty/config/theme/liquid_glass_border_edges.dart';
import 'package:hojaty/config/theme/liquid_glass_style.dart';
import 'package:hojaty/config/theme/liquid_glass_surface_variant.dart';
import 'package:hojaty/core/utils/extensions/context_extensions.dart';
import 'package:hojaty/core/widgets/liquid_glass_border_painter.dart';

/// Reusable Apple iOS 26 Liquid Glass container with zero overhead when disabled.
class LiquidGlassContainer extends StatelessWidget {
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
    final sigma = LiquidGlassStyle.clampSigma(blurSigma ?? style.defaultSigma);
    final effectiveRadius = borderRadius ?? BorderRadius.zero;
    final effectiveTint = customTintColor ?? style.tintColor;
    final effectiveRimColors = customBorderColor != null
        ? <Color>[
            customBorderColor!.withValues(alpha: 0.90),
            customBorderColor!.withValues(alpha: 0.35),
            customBorderColor!.withValues(alpha: 0.72),
          ]
        : style.borderGradientColors;

    final glassBody = BackdropFilter(
      filter: ImageFilter.compose(
        outer: ImageFilter.blur(
          sigmaX: sigma,
          sigmaY: sigma,
          tileMode: TileMode.clamp,
        ),
        inner: style.saturationFilter,
      ),
      child: CustomPaint(
        foregroundPainter: LiquidGlassBorderPainter(
          borderRadius: effectiveRadius,
          sheenColors: style.sheenColors,
          innerHighlightColor: style.innerHighlightColor,
          innerShadowColor: style.innerShadowColor,
          gradientColors: effectiveRimColors,
          strokeWidth: customBorderWidth ?? style.borderWidth,
          edges: borderEdges,
        ),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: effectiveTint,
            borderRadius: borderRadius,
          ),
          child: Padding(padding: padding ?? EdgeInsets.zero, child: child),
        ),
      ),
    );

    final clipped = borderRadius != null
        ? ClipRRect(borderRadius: effectiveRadius, child: glassBody)
        : ClipRect(child: glassBody);

    return RepaintBoundary(
      child: Container(
        width: width,
        height: height,
        constraints: constraints,
        margin: margin,
        decoration: showShadow
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
      ),
    );
  }
}

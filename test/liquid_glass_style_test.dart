import 'package:flutter_test/flutter_test.dart';
import 'package:hojaty/config/theme/app_theme_mode.dart';
import 'package:hojaty/config/theme/liquid_glass_style.dart';
import 'package:hojaty/config/theme/liquid_glass_surface_variant.dart';
import 'package:hojaty/core/local/user_hive_helper.dart';

void main() {
  group('Liquid Glass defaults & iOS 26 optical style tokens', () {
    test('platform default is enabled on iOS and disabled on Android/Web', () {
      expect(
        UserHiveHelper.resolveDefaultLiquidGlassEnabled(isIOS: true),
        isTrue,
      );
      expect(
        UserHiveHelper.resolveDefaultLiquidGlassEnabled(isIOS: false),
        isFalse,
      );
      expect(
        UserHiveHelper.resolveDefaultLiquidGlassEnabled(
          isIOS: true,
          isWeb: true,
        ),
        isFalse,
      );
    });

    test('clampSigma enforces 6.0-14.0 optical blur bounds', () {
      expect(
        LiquidGlassStyle.clampSigma(2.0),
        LiquidGlassStyle.minBlurSigma,
      );
      expect(
        LiquidGlassStyle.clampSigma(LiquidGlassStyle.minBlurSigma),
        LiquidGlassStyle.minBlurSigma,
      );
      expect(
        LiquidGlassStyle.clampSigma(LiquidGlassStyle.defaultBlurSigma),
        LiquidGlassStyle.defaultBlurSigma,
      );
      expect(
        LiquidGlassStyle.clampSigma(LiquidGlassStyle.maxBlurSigma),
        LiquidGlassStyle.maxBlurSigma,
      );
      expect(
        LiquidGlassStyle.clampSigma(36.0),
        LiquidGlassStyle.maxBlurSigma,
      );
    });

    test(
      'resolve returns cached calibrated optical tokens for every theme and variant',
      () {
        for (final mode in AppThemeMode.values) {
          for (final variant in LiquidGlassSurfaceVariant.values) {
            final style = LiquidGlassStyle.resolve(mode, variant: variant);
            final cached = LiquidGlassStyle.resolve(mode, variant: variant);

            expect(identical(style, cached), isTrue);
            expect(style.borderGradientColors.length, 3);
            expect(style.tintColor.a, greaterThan(0.0));
            expect(style.tintColor.a, lessThan(1.0));
          }
        }
      },
    );

    test(
      'Light mode brandHeader preserves deep emerald opacity for white-text legibility',
      () {
        final lightHeader = LiquidGlassStyle.resolve(
          AppThemeMode.light,
          variant: LiquidGlassSurfaceVariant.brandHeader,
        );
        expect(lightHeader.tintColor.a, greaterThanOrEqualTo(0.85));
      },
    );
  });
}

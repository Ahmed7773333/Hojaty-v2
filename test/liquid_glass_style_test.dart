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

    test('clampSigma enforces 14.0–24.0 optical blur bounds', () {
      expect(LiquidGlassStyle.clampSigma(4.0), 14.0);
      expect(LiquidGlassStyle.clampSigma(14.0), 14.0);
      expect(LiquidGlassStyle.clampSigma(18.0), 18.0);
      expect(LiquidGlassStyle.clampSigma(24.0), 24.0);
      expect(LiquidGlassStyle.clampSigma(36.0), 24.0);
    });

    test(
      'resolve produces calibrated translucent tokens for every theme and variant',
      () {
        for (final mode in AppThemeMode.values) {
          for (final variant in LiquidGlassSurfaceVariant.values) {
            final style = LiquidGlassStyle.resolve(mode, variant: variant);

            expect(
              style.defaultSigma,
              inInclusiveRange(
                LiquidGlassStyle.minBlurSigma,
                LiquidGlassStyle.maxBlurSigma,
              ),
            );
            expect(style.sheenColors.length, 3);
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

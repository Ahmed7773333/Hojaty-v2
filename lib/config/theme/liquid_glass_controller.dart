import 'package:material_ui/material_ui.dart';
import 'package:hojaty/core/local/user_hive_helper.dart';

class LiquidGlassController {
  LiquidGlassController._();

  static final ValueNotifier<bool> enabledNotifier = ValueNotifier<bool>(
    UserHiveHelper.getLiquidGlassEnabled(),
  );

  static bool get isEnabled => enabledNotifier.value;

  /// Syncs persisted preference after Hive opens.
  static Future<void> init() async {
    enabledNotifier.value = UserHiveHelper.getLiquidGlassEnabled();
  }

  static void setEnabled(bool enabled) {
    if (enabledNotifier.value == enabled) return;
    enabledNotifier.value = enabled;
    UserHiveHelper.setLiquidGlassEnabled(enabled);
  }

  static void toggle() => setEnabled(!isEnabled);
}

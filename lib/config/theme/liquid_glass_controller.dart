import 'package:material_ui/material_ui.dart';
import 'package:hojaty/core/local/user_hive_helper.dart';

class LiquidGlassController {
  LiquidGlassController._();

  static final ValueNotifier<bool> enabledNotifier = ValueNotifier<bool>(
    UserHiveHelper.getLiquidGlassEnabled(),
  );

  static bool get isEnabled => enabledNotifier.value;

  static void setEnabled(bool enabled) {
    enabledNotifier.value = enabled;
    UserHiveHelper.setLiquidGlassEnabled(enabled);
  }

  static void toggle() => setEnabled(!isEnabled);
}


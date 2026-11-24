import 'package:material_ui/material_ui.dart';
import 'package:hojaty/config/theme/liquid_glass_controller.dart';

class LiquidGlassScope extends InheritedNotifier<ValueNotifier<bool>> {
  const LiquidGlassScope({
    super.key,
    required ValueNotifier<bool> notifier,
    required super.child,
  }) : super(notifier: notifier);

  static bool of(BuildContext context) {
    final scope = context
        .dependOnInheritedWidgetOfExactType<LiquidGlassScope>();
    return scope?.notifier?.value ?? LiquidGlassController.isEnabled;
  }

  static bool read(BuildContext context) {
    final scope = context.getInheritedWidgetOfExactType<LiquidGlassScope>();
    return scope?.notifier?.value ?? LiquidGlassController.isEnabled;
  }
}


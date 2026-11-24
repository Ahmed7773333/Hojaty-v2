import 'package:material_ui/material_ui.dart';
import 'package:hojaty/config/theme/liquid_glass_controller.dart';
import 'package:hojaty/core/utils/extensions/context_extensions.dart';
import 'package:hojaty/features/homelayout/presentation/widgets/settings/settings_switch_tile_widget.dart';

class LiquidGlassSettingsTileWidget extends StatelessWidget {
  const LiquidGlassSettingsTileWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsSwitchTileWidget(
      title: context.strings.liquidGlassTitle,
      subtitle: context.strings.liquidGlassSubtitle,
      value: context.isLiquidGlassEnabled,
      onChanged: LiquidGlassController.setEnabled,
    );
  }
}


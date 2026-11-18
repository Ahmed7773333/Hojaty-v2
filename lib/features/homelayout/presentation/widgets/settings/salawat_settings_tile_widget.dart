import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hojaty/config/routes/app_router.dart';
import 'package:hojaty/core/utils/extensions/context_extensions.dart';
import 'package:hojaty/features/homelayout/presentation/bloc/homelayout_bloc.dart';
import 'package:hojaty/features/homelayout/presentation/bloc/homelayout_event.dart';
import 'package:hojaty/features/homelayout/presentation/bloc/homelayout_state.dart';
import 'package:hojaty/features/homelayout/presentation/widgets/settings/settings_switch_tile_widget.dart';
import 'package:hojaty/features/homelayout/presentation/widgets/settings/settings_tile_widget.dart';

class SalawatSettingsTileWidget extends StatelessWidget {
  const SalawatSettingsTileWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomelayoutBloc, HomelayoutState>(
      buildWhen: (prev, curr) =>
          prev.adhanSettings.isSalawatReminderEnabled !=
          curr.adhanSettings.isSalawatReminderEnabled,
      builder: (context, state) {
        final isSalawatEnabled = state.adhanSettings.isSalawatReminderEnabled;

        return Column(
          children: [
            SettingsTileWidget(
              title: context.strings.salawatReminderTitle,
              subtitle: isSalawatEnabled
                  ? context.strings.salawatReminderActiveSubtitle
                  : context.strings.salawatReminderDisabledSubtitle,
              onTap: () {
                context.pushNamed(AppRoutes.salawatSettings);
              },
            ),
            SettingsSwitchTileWidget(
              title: context.strings.salawatReminderSwitchLabel,
              value: isSalawatEnabled,
              onChanged: (val) {
                context.read<HomelayoutBloc>().add(
                  ToggleSalawatReminderEvent(val),
                );
              },
            ),
          ],
        );
      },
    );
  }
}

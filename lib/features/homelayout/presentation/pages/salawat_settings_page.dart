import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hojaty/core/utils/app_colors.dart';
import 'package:hojaty/core/utils/extensions/context_extensions.dart';
import 'package:hojaty/core/utils/screen_util_like.dart';
import 'package:hojaty/features/homelayout/presentation/bloc/homelayout_bloc.dart';
import 'package:hojaty/features/homelayout/presentation/bloc/homelayout_event.dart';
import 'package:hojaty/features/homelayout/presentation/bloc/homelayout_state.dart';
import 'package:hojaty/features/homelayout/presentation/widgets/salawat/salawat_hero_card_widget.dart';
import 'package:hojaty/features/homelayout/presentation/widgets/salawat/salawat_preview_card_widget.dart';
import 'package:hojaty/features/homelayout/presentation/widgets/salawat/salawat_sound_card_widget.dart';
import 'package:hojaty/features/homelayout/presentation/widgets/salawat/salawat_test_button_widget.dart';
import 'package:hojaty/features/homelayout/presentation/widgets/salawat/salawat_toggle_card_widget.dart';
import 'package:hojaty/features/homelayout/presentation/widgets/settings/settings_page_header_widget.dart';

class SalawatSettingsPage extends StatelessWidget {
  const SalawatSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkBackground
          : AppColors.lightBackground,
      body: Column(
        children: [
          SettingsPageHeaderWidget(
            title: context.strings.salawatSettingsTitle,
            subtitle: context.strings.salawatSettingsSubtitle,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
              child: BlocBuilder<HomelayoutBloc, HomelayoutState>(
                builder: (context, state) {
                  final isEnabled =
                      state.adhanSettings.isSalawatReminderEnabled;

                  return Column(
                    children: [
                      const SalawatHeroCardWidget(),
                      16.ver,
                      SalawatToggleCardWidget(
                        isEnabled: isEnabled,
                        onChanged: (val) {
                          context.read<HomelayoutBloc>().add(
                            ToggleSalawatReminderEvent(val),
                          );
                        },
                      ),
                      16.ver,
                      const SalawatSoundCardWidget(),
                      16.ver,
                      const SalawatPreviewCardWidget(),
                      20.ver,
                      const SalawatTestButtonWidget(),
                      28.ver,
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

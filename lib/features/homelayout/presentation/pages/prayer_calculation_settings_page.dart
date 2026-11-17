import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hojaty/core/local/user_hive_helper.dart';
import 'package:hojaty/core/utils/app_colors.dart';
import 'package:hojaty/core/utils/extensions/context_extensions.dart';
import 'package:hojaty/core/utils/local_notification_service.dart';
import 'package:hojaty/core/utils/screen_util_like.dart';
import 'package:hojaty/data/mocks/settings_mock_data.dart';
import 'package:hojaty/features/homelayout/presentation/bloc/homelayout_bloc.dart';
import 'package:hojaty/features/homelayout/presentation/bloc/homelayout_event.dart';
import 'package:hojaty/features/homelayout/presentation/widgets/prayer_times/adhan_sound_card_widget.dart';
import 'package:hojaty/features/homelayout/presentation/widgets/settings/settings_page_header_widget.dart';

class PrayerCalculationSettingsPage extends StatefulWidget {
  const PrayerCalculationSettingsPage({super.key});

  @override
  State<PrayerCalculationSettingsPage> createState() =>
      _PrayerCalculationSettingsPageState();
}

class _PrayerCalculationSettingsPageState
    extends State<PrayerCalculationSettingsPage> {
  late String _selectedSoundId;

  @override
  void initState() {
    super.initState();
    _selectedSoundId = UserHiveHelper.getSelectedAdhanSound();
  }

  void _onSoundSelected(String soundId) {
    setState(() {
      _selectedSoundId = soundId;
    });

    UserHiveHelper.setSelectedAdhanSound(soundId);

    try {
      context.read<HomelayoutBloc>().add(SelectAdhanSoundEvent(soundId));
    } catch (_) {
      final lang = Localizations.localeOf(context).languageCode;
      LocalNotificationService.showTestNotification(
        isFullAdhan: true,
        language: lang,
        soundId: soundId,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final sounds = SettingsMockData.adhanSounds;
    final currentSoundId = context.select(
      (HomelayoutBloc bloc) => bloc.state.adhanSettings.selectedSoundId,
    );
    final effectiveSoundId = currentSoundId.isNotEmpty
        ? currentSoundId
        : _selectedSoundId;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkBackground
          : AppColors.lightBackground,
      body: Column(
        children: [
          SettingsPageHeaderWidget(
            title: context.strings.prayerCalcSettingsTitle,
            subtitle: context.strings.prayerCalcSettingsSubtitle,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
              child: Column(
                children: [
                  // CalculationMethodCardWidget(
                  //   methods: methods,
                  //   selectedId: _selectedMethodId,
                  //   onSelect: (id) => setState(() => _selectedMethodId = id),
                  // ),
                  // 20.ver,
                  AdhanSoundCardWidget(
                    sounds: sounds,
                    selectedId: effectiveSoundId,
                    onSelect: _onSoundSelected,
                  ),
                  24.ver,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

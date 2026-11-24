import 'package:material_ui/material_ui.dart';
import 'package:hojaty/features/hojaty_ai/data/models/hojaty_starter_prompt_model.dart';
import 'package:hojaty/l10n/app_localizations.dart';

/// Provides 4 context-aware starter prompts based on current time of day & weekday.
class HojatyStarterPromptsProvider {
  const HojatyStarterPromptsProvider._();

  static List<HojatyStarterPromptModel> getPrompts(
    AppLocalizations strings, {
    DateTime? now,
  }) {
    final current = now ?? DateTime.now();
    final hour = current.hour;
    final isFriday = current.weekday == DateTime.friday;

    final HojatyStarterPromptModel primaryContextSlot;
    if (isFriday && hour >= 6 && hour < 15) {
      primaryContextSlot = HojatyStarterPromptModel(
        label: strings.hojatyAiStarterFridayKahf,
        prompt: strings.hojatyAiStarterFridayKahfPrompt,
        icon: Icons.play_circle_outline_rounded,
        isAction: true,
      );
    } else if (hour >= 4 && hour < 12) {
      primaryContextSlot = HojatyStarterPromptModel(
        label: strings.hojatyAiStarterMorningAthkar,
        prompt: strings.hojatyAiStarterMorningAthkarPrompt,
        icon: Icons.wb_sunny_outlined,
        isAction: true,
      );
    } else if (hour >= 12 && hour < 15) {
      primaryContextSlot = HojatyStarterPromptModel(
        label: strings.hojatyAiStarterPrayerTimes,
        prompt: strings.hojatyAiStarterPrayerTimesPrompt,
        icon: Icons.access_time_rounded,
        isAction: true,
      );
    } else if (hour >= 15 && hour < 21) {
      primaryContextSlot = HojatyStarterPromptModel(
        label: strings.hojatyAiStarterEveningAthkar,
        prompt: strings.hojatyAiStarterEveningAthkarPrompt,
        icon: Icons.nights_stay_outlined,
        isAction: true,
      );
    } else {
      primaryContextSlot = HojatyStarterPromptModel(
        label: strings.hojatyAiStarterSleepAthkar,
        prompt: strings.hojatyAiStarterSleepAthkarPrompt,
        icon: Icons.bedtime_outlined,
        isAction: true,
      );
    }

    final HojatyStarterPromptModel secondaryActionSlot =
        (hour >= 12 && hour < 15 && !isFriday)
            ? HojatyStarterPromptModel(
                label: strings.hojatyAiStarterEveningAthkar,
                prompt: strings.hojatyAiStarterEveningAthkarPrompt,
                icon: Icons.nights_stay_outlined,
                isAction: true,
              )
            : HojatyStarterPromptModel(
                label: strings.hojatyAiStarterPrayerTimes,
                prompt: strings.hojatyAiStarterPrayerTimesPrompt,
                icon: Icons.access_time_rounded,
                isAction: true,
              );

    return [
      primaryContextSlot,
      secondaryActionSlot,
      HojatyStarterPromptModel(
        label: strings.hojatyAiStarterTafsirKursi,
        prompt: strings.hojatyAiStarterTafsirKursiPrompt,
        icon: Icons.menu_book_rounded,
      ),
      HojatyStarterPromptModel(
        label: strings.hojatyAiStarterReliefDua,
        prompt: strings.hojatyAiStarterReliefDuaPrompt,
        icon: Icons.favorite_outline_rounded,
      ),
    ];
  }
}

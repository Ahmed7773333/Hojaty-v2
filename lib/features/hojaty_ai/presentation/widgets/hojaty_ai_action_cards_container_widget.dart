import 'package:material_ui/material_ui.dart';
import 'package:hojaty/features/hojaty_ai/data/datasources/hojaty_tool_registry.dart';
import 'package:hojaty/features/hojaty_ai/data/models/ai_tool_call_model.dart';
import 'package:hojaty/features/hojaty_ai/presentation/widgets/hojaty_ai_audio_action_card_widget.dart';
import 'package:hojaty/features/hojaty_ai/presentation/widgets/hojaty_ai_prayer_action_card_widget.dart';
import 'package:hojaty/features/hojaty_ai/presentation/widgets/hojaty_ai_quran_action_card_widget.dart';
import 'package:hojaty/features/hojaty_ai/presentation/widgets/hojaty_ai_status_action_card_widget.dart';

class HojatyAiActionCardsContainerWidget extends StatelessWidget {
  final List<AiToolActionResultModel> actionResults;

  const HojatyAiActionCardsContainerWidget({
    super.key,
    required this.actionResults,
  });

  @override
  Widget build(BuildContext context) {
    if (actionResults.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: actionResults.map((action) {
        switch (action.toolName) {
          case HojatyToolRegistry.toolPlayQuranAudio:
            return HojatyAiAudioActionCardWidget(action: action);
          case HojatyToolRegistry.toolGetPrayerTimes:
            return HojatyAiPrayerActionCardWidget(action: action);
          case HojatyToolRegistry.toolOpenQuranReader:
            return HojatyAiQuranActionCardWidget(action: action);
          default:
            return HojatyAiStatusActionCardWidget(action: action);
        }
      }).toList(),
    );
  }
}


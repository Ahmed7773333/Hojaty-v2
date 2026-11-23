import 'package:hojaty/features/hojaty_ai/data/models/ai_tool_call_model.dart';

class HojatyAiStreamChunk {
  final String? text;
  final AiToolCallModel? toolCall;

  const HojatyAiStreamChunk({
    this.text,
    this.toolCall,
  });

  bool get hasText => text != null && text!.isNotEmpty;
  bool get hasToolCall => toolCall != null;
}


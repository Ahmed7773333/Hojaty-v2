import 'package:material_ui/material_ui.dart';
import 'package:hojaty/core/utils/screen_util_like.dart';
import 'package:hojaty/features/hojaty_ai/data/models/chat_message_model.dart';
import 'package:hojaty/features/hojaty_ai/data/models/rag_chunk_model.dart';
import 'package:hojaty/features/hojaty_ai/presentation/bloc/hojaty_ai_state.dart';
import 'package:hojaty/features/hojaty_ai/presentation/widgets/hojaty_ai_bot_bubble_widget.dart';
import 'package:hojaty/features/hojaty_ai/presentation/widgets/hojaty_ai_streaming_bubble_widget.dart';
import 'package:hojaty/features/hojaty_ai/presentation/widgets/hojaty_ai_user_bubble_widget.dart';

class HojatyAiMessagesListWidget extends StatefulWidget {
  final List<ChatMessageModel> messages;
  final bool isStreaming;
  final HojatyAiProcessingStage processingStage;
  final String streamingText;
  final List<RagChunkModel> currentSources;

  const HojatyAiMessagesListWidget({
    super.key,
    required this.messages,
    required this.isStreaming,
    required this.processingStage,
    required this.streamingText,
    required this.currentSources,
  });

  @override
  State<HojatyAiMessagesListWidget> createState() =>
      _HojatyAiMessagesListWidgetState();
}

class _HojatyAiMessagesListWidgetState
    extends State<HojatyAiMessagesListWidget> {
  final ScrollController _scrollController = ScrollController();

  @override
  void didUpdateWidget(covariant HojatyAiMessagesListWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.messages.length != oldWidget.messages.length ||
        widget.streamingText.length != oldWidget.streamingText.length) {
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final totalCount = widget.messages.length + (widget.isStreaming ? 1 : 0);

    return ListView.builder(
      controller: _scrollController,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      itemCount: totalCount,
      itemBuilder: (context, index) {
        if (index < widget.messages.length) {
          final msg = widget.messages[index];
          if (msg.sender == MessageSender.user) {
            return HojatyAiUserBubbleWidget(message: msg);
          } else {
            return HojatyAiBotBubbleWidget(message: msg);
          }
        } else {
          return HojatyAiStreamingBubbleWidget(
            text: widget.streamingText,
            sources: widget.currentSources,
            processingStage: widget.processingStage,
          );
        }
      },
    );
  }
}

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/chat_message_model.dart';
import '../../data/models/rag_chunk_model.dart';
import '../../data/repositories/hojaty_ai_repository.dart';
import 'hojaty_ai_state.dart';

class HojatyAiCubit extends Cubit<HojatyAiState> {
  final HojatyAiRepository _repository;
  StreamSubscription<String>? _generationSubscription;

  HojatyAiCubit(this._repository) : super(const HojatyAiState());

  Future<void> sendMessage(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty || state.isStreaming) return;

    final userMessage = ChatMessageModel(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      text: trimmed,
      sender: MessageSender.user,
      timestamp: DateTime.now(),
    );

    emit(state.copyWith(
      status: HojatyAiStatus.loading,
      messages: [...state.messages, userMessage],
      clearErrorMessage: true,
      isStreaming: true,
      currentStreamingText: '',
      currentSources: const [],
    ));

    try {
      // Step A: Get Query Embedding
      debugPrint('HojatyAiCubit: Getting embedding...');
      final queryVector = await _repository.getEmbedding(trimmed);
      debugPrint('HojatyAiCubit: Embedding result: ${queryVector != null ? '${queryVector.length} dims' : 'null (will use keyword fallback)'}');

      if (isClosed) return;

      // Step B: Retrieve Grounded Islamic Sources
      debugPrint('HojatyAiCubit: Retrieving sources...');
      final sources = await _repository.retrieveSources(
        trimmed,
        queryVector: queryVector,
      );
      debugPrint('HojatyAiCubit: Found ${sources.length} sources');

      if (isClosed) return;

      emit(state.copyWith(currentSources: sources));

      // Step C: Stream Grounded Answer Generation
      final textBuffer = StringBuffer();
      await _generationSubscription?.cancel();

      final completer = Completer<void>();

      _generationSubscription = _repository
          .generateAnswerStream(userMessage: trimmed, sources: sources)
          .listen(
        (chunk) {
          if (isClosed) return;
          textBuffer.write(chunk);
          emit(state.copyWith(
            currentStreamingText: textBuffer.toString(),
          ));
        },
        onError: (err) {
          debugPrint('HojatyAiCubit: Generation stream error: $err');
          if (!isClosed) {
            _finalizeBotMessage(
              text: textBuffer.isNotEmpty
                  ? textBuffer.toString()
                  : 'حدث خطأ أثناء معالجة الطلب. يرجى المحاولة مرة أخرى.',
              sources: sources,
              isOffline: true,
            );
          }
          if (!completer.isCompleted) completer.complete();
        },
        onDone: () {
          debugPrint('HojatyAiCubit: Generation stream done (buffer length=${textBuffer.length})');
          if (!isClosed) {
            if (textBuffer.isEmpty) {
              // Stream finished but produced nothing — treat as offline
              _finalizeBotMessage(
                text: 'تعذر الحصول على إجابة من الخادم. يرجى المحاولة مرة أخرى.',
                sources: sources,
                isOffline: true,
              );
            } else {
              _finalizeBotMessage(
                text: textBuffer.toString(),
                sources: sources,
                isOffline: false,
              );
            }
          }
          if (!completer.isCompleted) completer.complete();
        },
        cancelOnError: false,
      );

      // Wait for stream to finish so that any exception after listen setup
      // doesn't leave isStreaming=true forever
      await completer.future;
    } catch (e, st) {
      debugPrint('HojatyAiCubit: sendMessage error: $e\n$st');
      if (!isClosed) {
        emit(state.copyWith(
          status: HojatyAiStatus.failure,
          errorMessage: e.toString(),
          isStreaming: false,
          currentStreamingText: '',
        ));
      }
    }
  }

  void _finalizeBotMessage({
    required String text,
    required List<RagChunkModel> sources,
    required bool isOffline,
  }) {
    final botMessage = ChatMessageModel(
      id: '${DateTime.now().microsecondsSinceEpoch}_bot',
      text: text.trim(),
      sender: MessageSender.ai,
      timestamp: DateTime.now(),
      sources: sources,
      isOffline: isOffline,
    );

    emit(state.copyWith(
      status: HojatyAiStatus.success,
      messages: [...state.messages, botMessage],
      isStreaming: false,
      currentStreamingText: '',
      currentSources: const [],
    ));
  }

  void clearChat() {
    _generationSubscription?.cancel();
    emit(const HojatyAiState());
  }

  @override
  Future<void> close() {
    _generationSubscription?.cancel();
    return super.close();
  }
}

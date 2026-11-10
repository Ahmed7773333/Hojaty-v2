import 'package:equatable/equatable.dart';
import '../../data/models/chat_message_model.dart';
import '../../data/models/rag_chunk_model.dart';

enum HojatyAiStatus {
  initial,
  loading,
  success,
  failure,
}

class HojatyAiState extends Equatable {
  final HojatyAiStatus status;
  final List<ChatMessageModel> messages;
  final String? errorMessage;
  final bool isStreaming;
  final String currentStreamingText;
  final List<RagChunkModel> currentSources;

  const HojatyAiState({
    this.status = HojatyAiStatus.initial,
    this.messages = const [],
    this.errorMessage,
    this.isStreaming = false,
    this.currentStreamingText = '',
    this.currentSources = const [],
  });

  HojatyAiState copyWith({
    HojatyAiStatus? status,
    List<ChatMessageModel>? messages,
    String? errorMessage,
    bool clearErrorMessage = false,
    bool? isStreaming,
    String? currentStreamingText,
    List<RagChunkModel>? currentSources,
  }) {
    return HojatyAiState(
      status: status ?? this.status,
      messages: messages ?? this.messages,
      errorMessage: clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
      isStreaming: isStreaming ?? this.isStreaming,
      currentStreamingText: currentStreamingText ?? this.currentStreamingText,
      currentSources: currentSources ?? this.currentSources,
    );
  }

  @override
  List<Object?> get props => [
        status,
        messages,
        errorMessage,
        isStreaming,
        currentStreamingText,
        currentSources,
      ];
}


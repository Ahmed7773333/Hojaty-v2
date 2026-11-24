import 'package:equatable/equatable.dart';
import 'package:hojaty/features/hojaty_ai/data/models/chat_message_model.dart';
import 'package:hojaty/features/hojaty_ai/data/models/chat_session_model.dart';
import 'package:hojaty/features/hojaty_ai/data/models/rag_chunk_model.dart';

enum HojatyAiStatus {
  initial,
  loading,
  success,
  failure,
}

enum HojatyAiAssetStatus {
  ready,
  checking,
  requiresDownload,
  downloading,
  failed,
}

enum HojatyAiProcessingStage {
  idle,
  searchingSources,
  executingTool,
  generating,
}

class HojatyAiState extends Equatable {
  final HojatyAiStatus status;
  final List<ChatMessageModel> messages;
  final String? errorMessage;
  final bool isStreaming;
  final HojatyAiProcessingStage processingStage;
  final String currentStreamingText;
  final List<RagChunkModel> currentSources;

  // Local Chat History
  final String? currentSessionId;
  final List<ChatSessionModel> historySessions;

  // Asset delivery status for on-demand RAG database
  final HojatyAiAssetStatus assetStatus;
  final double downloadProgress;
  final int bytesDownloaded;
  final int totalBytes;

  const HojatyAiState({
    this.status = HojatyAiStatus.initial,
    this.messages = const [],
    this.errorMessage,
    this.isStreaming = false,
    this.processingStage = HojatyAiProcessingStage.idle,
    this.currentStreamingText = '',
    this.currentSources = const [],
    this.currentSessionId,
    this.historySessions = const [],
    this.assetStatus = HojatyAiAssetStatus.checking,
    this.downloadProgress = 0.0,
    this.bytesDownloaded = 0,
    this.totalBytes = 248000512,
  });

  HojatyAiState copyWith({
    HojatyAiStatus? status,
    List<ChatMessageModel>? messages,
    String? errorMessage,
    bool clearErrorMessage = false,
    bool? isStreaming,
    HojatyAiProcessingStage? processingStage,
    String? currentStreamingText,
    List<RagChunkModel>? currentSources,
    String? currentSessionId,
    bool clearCurrentSessionId = false,
    List<ChatSessionModel>? historySessions,
    HojatyAiAssetStatus? assetStatus,
    double? downloadProgress,
    int? bytesDownloaded,
    int? totalBytes,
  }) {
    return HojatyAiState(
      status: status ?? this.status,
      messages: messages ?? this.messages,
      errorMessage: clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
      isStreaming: isStreaming ?? this.isStreaming,
      processingStage: processingStage ?? this.processingStage,
      currentStreamingText: currentStreamingText ?? this.currentStreamingText,
      currentSources: currentSources ?? this.currentSources,
      currentSessionId: clearCurrentSessionId
          ? null
          : (currentSessionId ?? this.currentSessionId),
      historySessions: historySessions ?? this.historySessions,
      assetStatus: assetStatus ?? this.assetStatus,
      downloadProgress: downloadProgress ?? this.downloadProgress,
      bytesDownloaded: bytesDownloaded ?? this.bytesDownloaded,
      totalBytes: totalBytes ?? this.totalBytes,
    );
  }

  @override
  List<Object?> get props => [
        status,
        messages,
        errorMessage,
        isStreaming,
        processingStage,
        currentStreamingText,
        currentSources,
        currentSessionId,
        historySessions,
        assetStatus,
        downloadProgress,
        bytesDownloaded,
        totalBytes,
      ];
}


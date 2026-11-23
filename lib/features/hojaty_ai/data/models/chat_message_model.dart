import 'package:equatable/equatable.dart';
import 'package:hojaty/features/hojaty_ai/data/models/ai_tool_call_model.dart';
import 'package:hojaty/features/hojaty_ai/data/models/rag_chunk_model.dart';

enum MessageSender { user, ai }

class ChatMessageModel extends Equatable {
  final String id;
  final String text;
  final MessageSender sender;
  final DateTime timestamp;
  final List<RagChunkModel> sources;
  final List<AiToolActionResultModel> actionResults;
  final bool isStreaming;
  final bool isOffline;

  const ChatMessageModel({
    required this.id,
    required this.text,
    required this.sender,
    required this.timestamp,
    this.sources = const [],
    this.actionResults = const [],
    this.isStreaming = false,
    this.isOffline = false,
  });

  ChatMessageModel copyWith({
    String? id,
    String? text,
    MessageSender? sender,
    DateTime? timestamp,
    List<RagChunkModel>? sources,
    List<AiToolActionResultModel>? actionResults,
    bool? isStreaming,
    bool? isOffline,
  }) {
    return ChatMessageModel(
      id: id ?? this.id,
      text: text ?? this.text,
      sender: sender ?? this.sender,
      timestamp: timestamp ?? this.timestamp,
      sources: sources ?? this.sources,
      actionResults: actionResults ?? this.actionResults,
      isStreaming: isStreaming ?? this.isStreaming,
      isOffline: isOffline ?? this.isOffline,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'sender': sender.name,
      'timestamp': timestamp.toIso8601String(),
      'sources': sources.map((s) => s.toMap()).toList(),
      'actionResults': actionResults.map((a) => a.toJson()).toList(),
      'isOffline': isOffline,
    };
  }

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    final senderName = json['sender'] as String? ?? 'user';
    final rawSources = json['sources'] as List<dynamic>? ?? const [];
    final parsedSources = rawSources
        .whereType<Map>()
        .map((m) => RagChunkModel.fromMap(Map<String, dynamic>.from(m)))
        .toList();

    final rawActions = json['actionResults'] as List<dynamic>? ?? const [];
    final parsedActions = rawActions
        .whereType<Map>()
        .map((a) => AiToolActionResultModel.fromJson(Map<String, dynamic>.from(a)))
        .toList();

    return ChatMessageModel(
      id: json['id'] as String? ?? '',
      text: json['text'] as String? ?? '',
      sender: senderName == MessageSender.ai.name
          ? MessageSender.ai
          : MessageSender.user,
      timestamp: DateTime.tryParse(json['timestamp'] as String? ?? '') ??
          DateTime.now(),
      sources: parsedSources,
      actionResults: parsedActions,
      isOffline: json['isOffline'] as bool? ?? false,
    );
  }

  @override
  List<Object?> get props => [
        id,
        text,
        sender,
        timestamp,
        sources,
        actionResults,
        isStreaming,
        isOffline,
      ];
}


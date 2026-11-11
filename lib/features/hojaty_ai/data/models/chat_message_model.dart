import 'package:equatable/equatable.dart';
import 'rag_chunk_model.dart';

enum MessageSender { user, ai }

class ChatMessageModel extends Equatable {
  final String id;
  final String text;
  final MessageSender sender;
  final DateTime timestamp;
  final List<RagChunkModel> sources;
  final bool isStreaming;
  final bool isOffline;

  const ChatMessageModel({
    required this.id,
    required this.text,
    required this.sender,
    required this.timestamp,
    this.sources = const [],
    this.isStreaming = false,
    this.isOffline = false,
  });

  ChatMessageModel copyWith({
    String? id,
    String? text,
    MessageSender? sender,
    DateTime? timestamp,
    List<RagChunkModel>? sources,
    bool? isStreaming,
    bool? isOffline,
  }) {
    return ChatMessageModel(
      id: id ?? this.id,
      text: text ?? this.text,
      sender: sender ?? this.sender,
      timestamp: timestamp ?? this.timestamp,
      sources: sources ?? this.sources,
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

    return ChatMessageModel(
      id: json['id'] as String? ?? '',
      text: json['text'] as String? ?? '',
      sender: senderName == MessageSender.ai.name
          ? MessageSender.ai
          : MessageSender.user,
      timestamp: DateTime.tryParse(json['timestamp'] as String? ?? '') ??
          DateTime.now(),
      sources: parsedSources,
      isStreaming: false,
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
        isStreaming,
        isOffline,
      ];
}


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


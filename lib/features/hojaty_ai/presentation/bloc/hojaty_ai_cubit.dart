import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/play_asset_delivery_service.dart';
import '../../data/datasources/hojaty_chat_history_local_data_source.dart';
import '../../data/models/chat_message_model.dart';
import '../../data/models/chat_session_model.dart';
import '../../data/models/rag_chunk_model.dart';
import '../../data/repositories/hojaty_ai_repository.dart';
import 'hojaty_ai_state.dart';

class HojatyAiCubit extends Cubit<HojatyAiState> {
  final HojatyAiRepository _repository;
  final HojatyChatHistoryLocalDataSource _historyDataSource;
  StreamSubscription<String>? _generationSubscription;
  StreamSubscription<AssetPackInfo>? _downloadSubscription;

  HojatyAiCubit(
    this._repository,
    this._historyDataSource,
  ) : super(const HojatyAiState());

  Future<void> init() async {
    await checkAssetStatus();
    await loadHistory();
  }

  /// Loads saved local chat history and restores the active session if any.
  Future<void> loadHistory() async {
    try {
      final sessions = await _historyDataSource.getAllSessions();
      final activeId = await _historyDataSource.getActiveSessionId();

      ChatSessionModel? activeSession;
      if (activeId != null) {
        for (final s in sessions) {
          if (s.id == activeId) {
            activeSession = s;
            break;
          }
        }
      }

      if (!isClosed) {
        emit(state.copyWith(
          historySessions: sessions,
          currentSessionId: activeSession?.id,
          messages: activeSession?.messages ?? state.messages,
        ));
      }
    } catch (e) {
      debugPrint('HojatyAiCubit.loadHistory error: $e');
    }
  }

  /// Checks whether the hojaty_rag database asset is downloaded/ready.
  /// In debug mode (kDebugMode), it is immediately ready.
  Future<void> checkAssetStatus() async {
    if (kDebugMode) {
      emit(state.copyWith(assetStatus: HojatyAiAssetStatus.ready));
      return;
    }

    emit(state.copyWith(assetStatus: HojatyAiAssetStatus.checking));

    try {
      // 1. Direct installed asset pack path check
      final packPath = await PlayAssetDeliveryService.getAssetPackPath('hojaty_rag');
      if (packPath != null && packPath.isNotEmpty) {
        final file = File('$packPath/hojaty_rag.db');
        if (await file.exists()) {
          emit(state.copyWith(assetStatus: HojatyAiAssetStatus.ready));
          return;
        }
      }

      // 2. Local module assets check (for desktop/local release testing)
      final directFile = File('android/hojaty_rag/src/main/assets/hojaty_rag.db');
      if (await directFile.exists()) {
        emit(state.copyWith(assetStatus: HojatyAiAssetStatus.ready));
        return;
      }

      // 3. Play Core asset pack status check
      final info = await PlayAssetDeliveryService.getAssetPackStatus('hojaty_rag');
      if (info.isDownloaded && info.assetsPath != null) {
        final file = File('${info.assetsPath}/hojaty_rag.db');
        if (await file.exists()) {
          emit(state.copyWith(assetStatus: HojatyAiAssetStatus.ready));
          return;
        }
      }

      if (info.status == AssetPackStateStatus.downloading ||
          info.status == AssetPackStateStatus.transferring) {
        _listenToDownloadStream();
        emit(state.copyWith(
          assetStatus: HojatyAiAssetStatus.downloading,
          downloadProgress: info.progress,
          bytesDownloaded: info.bytesDownloaded,
          totalBytes: info.totalBytes > 0 ? info.totalBytes : 248000512,
        ));
        return;
      }

      emit(state.copyWith(assetStatus: HojatyAiAssetStatus.requiresDownload));
    } catch (e) {
      debugPrint('HojatyAiCubit: Error checking asset pack status: $e');
      emit(state.copyWith(assetStatus: HojatyAiAssetStatus.requiresDownload));
    }
  }

  /// Initiates downloading the on-demand RAG asset pack from Play Store.
  Future<void> startDownload() async {
    emit(state.copyWith(
      assetStatus: HojatyAiAssetStatus.downloading,
      downloadProgress: 0.0,
      bytesDownloaded: 0,
      totalBytes: 248000512,
    ));

    _listenToDownloadStream();
    final success = await PlayAssetDeliveryService.startDownload('hojaty_rag');
    if (!success && !isClosed) {
      emit(state.copyWith(assetStatus: HojatyAiAssetStatus.failed));
    }
  }

  /// Cancels an in-progress asset pack download.
  Future<void> cancelDownload() async {
    await _downloadSubscription?.cancel();
    _downloadSubscription = null;
    await PlayAssetDeliveryService.cancelDownload('hojaty_rag');
    if (!isClosed) {
      emit(state.copyWith(
        assetStatus: HojatyAiAssetStatus.requiresDownload,
        downloadProgress: 0.0,
        bytesDownloaded: 0,
      ));
    }
  }

  void _listenToDownloadStream() {
    _downloadSubscription?.cancel();
    _downloadSubscription = PlayAssetDeliveryService.downloadProgressStream.listen(
      (event) {
        if (isClosed || event.packName != 'hojaty_rag') return;

        if (event.isDownloaded || event.status == AssetPackStateStatus.completed) {
          emit(state.copyWith(
            assetStatus: HojatyAiAssetStatus.ready,
            downloadProgress: 1.0,
            bytesDownloaded: event.totalBytes > 0 ? event.totalBytes : 248000512,
            totalBytes: event.totalBytes > 0 ? event.totalBytes : 248000512,
          ));
          _downloadSubscription?.cancel();
          _downloadSubscription = null;
        } else if (event.status == AssetPackStateStatus.failed ||
            event.status == AssetPackStateStatus.canceled) {
          emit(state.copyWith(assetStatus: HojatyAiAssetStatus.failed));
          _downloadSubscription?.cancel();
          _downloadSubscription = null;
        } else if (event.status == AssetPackStateStatus.downloading ||
            event.status == AssetPackStateStatus.transferring) {
          emit(state.copyWith(
            assetStatus: HojatyAiAssetStatus.downloading,
            downloadProgress: event.progress,
            bytesDownloaded: event.bytesDownloaded,
            totalBytes: event.totalBytes > 0 ? event.totalBytes : 248000512,
          ));
        }
      },
    );
  }

  Future<void> sendMessage(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty || state.isStreaming) return;

    final userMessage = ChatMessageModel(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      text: trimmed,
      sender: MessageSender.user,
      timestamp: DateTime.now(),
    );

    final updatedMessages = [...state.messages, userMessage];
    emit(state.copyWith(
      status: HojatyAiStatus.loading,
      messages: updatedMessages,
      clearErrorMessage: true,
      isStreaming: true,
      currentStreamingText: '',
      currentSources: const [],
    ));

    await _persistMessages(updatedMessages);

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

    final updatedMessages = [...state.messages, botMessage];
    emit(state.copyWith(
      status: HojatyAiStatus.success,
      messages: updatedMessages,
      isStreaming: false,
      currentStreamingText: '',
      currentSources: const [],
    ));

    _persistMessages(updatedMessages);
  }

  Future<void> _persistMessages(List<ChatMessageModel> updatedMessages) async {
    if (updatedMessages.isEmpty) return;

    final now = DateTime.now();
    final sessionId = state.currentSessionId ?? now.microsecondsSinceEpoch.toString();

    ChatSessionModel? existing;
    for (final s in state.historySessions) {
      if (s.id == sessionId) {
        existing = s;
        break;
      }
    }

    final firstUserText = updatedMessages
        .firstWhere(
          (m) => m.sender == MessageSender.user,
          orElse: () => updatedMessages.first,
        )
        .text
        .replaceAll('\n', ' ')
        .trim();

    final title = firstUserText.length > 60
        ? '${firstUserText.substring(0, 60)}...'
        : firstUserText;

    final session = existing != null
        ? existing.copyWith(updatedAt: now, messages: updatedMessages)
        : ChatSessionModel(
            id: sessionId,
            title: title,
            createdAt: now,
            updatedAt: now,
            messages: updatedMessages,
          );

    await _historyDataSource.saveSession(session);
    await _historyDataSource.setActiveSessionId(sessionId);

    final updatedSessions = [
      session,
      ...state.historySessions.where((s) => s.id != sessionId),
    ]..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));

    if (!isClosed) {
      emit(state.copyWith(
        currentSessionId: sessionId,
        historySessions: updatedSessions,
      ));
    }
  }

  /// Starts a fresh chat session while keeping older conversations saved in history.
  Future<void> startNewChat() async {
    await _generationSubscription?.cancel();
    await _historyDataSource.setActiveSessionId(null);

    if (!isClosed) {
      emit(state.copyWith(
        clearCurrentSessionId: true,
        messages: const [],
        isStreaming: false,
        currentStreamingText: '',
        currentSources: const [],
        status: HojatyAiStatus.initial,
        clearErrorMessage: true,
      ));
    }
  }

  /// Loads a previous conversation from local history.
  Future<void> selectSession(String sessionId) async {
    await _generationSubscription?.cancel();

    ChatSessionModel? target;
    for (final s in state.historySessions) {
      if (s.id == sessionId) {
        target = s;
        break;
      }
    }
    target ??= await _historyDataSource.getSession(sessionId);

    if (target == null) return;

    await _historyDataSource.setActiveSessionId(target.id);
    if (!isClosed) {
      emit(state.copyWith(
        currentSessionId: target.id,
        messages: target.messages,
        isStreaming: false,
        currentStreamingText: '',
        currentSources: const [],
        status: HojatyAiStatus.success,
        clearErrorMessage: true,
      ));
    }
  }

  /// Deletes a single conversation from local history.
  Future<void> deleteSession(String sessionId) async {
    await _historyDataSource.deleteSession(sessionId);
    final updatedSessions = await _historyDataSource.getAllSessions();

    if (!isClosed) {
      if (state.currentSessionId == sessionId) {
        emit(state.copyWith(
          clearCurrentSessionId: true,
          messages: const [],
          historySessions: updatedSessions,
          isStreaming: false,
          currentStreamingText: '',
          currentSources: const [],
          status: HojatyAiStatus.initial,
          clearErrorMessage: true,
        ));
      } else {
        emit(state.copyWith(historySessions: updatedSessions));
      }
    }
  }

  /// Deletes all saved chat history.
  Future<void> clearAllHistory() async {
    await _generationSubscription?.cancel();
    await _historyDataSource.clearAllSessions();

    if (!isClosed) {
      emit(state.copyWith(
        clearCurrentSessionId: true,
        messages: const [],
        historySessions: const [],
        isStreaming: false,
        currentStreamingText: '',
        currentSources: const [],
        status: HojatyAiStatus.initial,
        clearErrorMessage: true,
      ));
    }
  }

  void clearChat() {
    startNewChat();
  }

  @override
  Future<void> close() {
    _generationSubscription?.cancel();
    _downloadSubscription?.cancel();
    return super.close();
  }
}

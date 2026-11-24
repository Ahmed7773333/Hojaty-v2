import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hojaty/core/utils/play_asset_delivery_service.dart';
import 'package:hojaty/features/hojaty_ai/data/datasources/hojaty_chat_history_local_data_source.dart';
import 'package:hojaty/features/hojaty_ai/data/models/ai_tool_call_model.dart';
import 'package:hojaty/features/hojaty_ai/data/models/chat_message_model.dart';
import 'package:hojaty/features/hojaty_ai/data/models/chat_session_model.dart';
import 'package:hojaty/features/hojaty_ai/data/models/hojaty_ai_stream_chunk.dart';
import 'package:hojaty/features/hojaty_ai/data/models/rag_chunk_model.dart';
import 'package:hojaty/features/hojaty_ai/data/repositories/hojaty_ai_repository.dart';
import 'package:hojaty/features/hojaty_ai/domain/services/app_action_dispatcher.dart';
import 'package:hojaty/features/hojaty_ai/domain/services/hojaty_query_router.dart';
import 'package:hojaty/features/hojaty_ai/presentation/bloc/hojaty_ai_state.dart';

class HojatyAiCubit extends Cubit<HojatyAiState> {
  final HojatyAiRepository _repository;
  final HojatyChatHistoryLocalDataSource _historyDataSource;
  final AppActionDispatcher _actionDispatcher;
  final HojatyQueryRouter _router;
  StreamSubscription<HojatyAiStreamChunk>? _generationSubscription;
  StreamSubscription<AssetPackInfo>? _downloadSubscription;

  HojatyAiCubit(
    this._repository,
    this._historyDataSource, {
    AppActionDispatcher? actionDispatcher,
    HojatyQueryRouter? router,
  })  : _actionDispatcher = actionDispatcher ?? AppActionDispatcher(),
        _router = router ?? const HojatyQueryRouter(),
        super(const HojatyAiState());

  AppActionDispatcher get actionDispatcher => _actionDispatcher;
  Stream<AppActionNavigationEvent> get navigationEvents =>
      _actionDispatcher.navigationEvents;

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

  Future<void> sendMessage(String text, {String localeCode = 'ar'}) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty || state.isStreaming) return;

    final userMessage = ChatMessageModel(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      text: trimmed,
      sender: MessageSender.user,
      timestamp: DateTime.now(),
    );

    // 0. Pre-execution 3-way intent gate (synchronous, zero API cost)
    final routeResult = _router.classify(trimmed, localeCode: localeCode);
    debugPrint(
      'HojatyAiCubit: Intent=${routeResult.intent}, Route=${routeResult.route}',
    );

    // Route A: NO_OP (Gibberish / Chitchat / Off-topic) -> Instant reply with zero loader delay
    if (routeResult.intent == HojatyIntent.noOp) {
      final botMessage = ChatMessageModel(
        id: '${DateTime.now().microsecondsSinceEpoch}_bot',
        text: (routeResult.instantReply ?? 'كيف يمكنني مساعدتك اليوم؟').trim(),
        sender: MessageSender.ai,
        timestamp: DateTime.now(),
      );
      final updatedMessages = [...state.messages, userMessage, botMessage];
      emit(state.copyWith(
        status: HojatyAiStatus.success,
        messages: updatedMessages,
        clearErrorMessage: true,
        isStreaming: false,
        processingStage: HojatyAiProcessingStage.idle,
        currentStreamingText: '',
        currentSources: const [],
      ));
      await _persistMessages(updatedMessages);
      return;
    }

    final initialStage = routeResult.intent == HojatyIntent.actionTool
        ? HojatyAiProcessingStage.executingTool
        : HojatyAiProcessingStage.searchingSources;

    final updatedMessages = [...state.messages, userMessage];
    emit(state.copyWith(
      status: HojatyAiStatus.loading,
      messages: updatedMessages,
      clearErrorMessage: true,
      isStreaming: true,
      processingStage: initialStage,
      currentStreamingText: '',
      currentSources: const [],
    ));

    await _persistMessages(updatedMessages);

    List<RagChunkModel> currentWorkingSources = const [];

    try {
      // Route B: ACTION_TOOL -> Execute Tool ONLY (0 RAG, 0 Embeddings)
      if (routeResult.intent == HojatyIntent.actionTool) {
        if (routeResult.route == HojatyQueryRoute.directToolCommand &&
            routeResult.directToolCall != null) {
          final actionResult = await _actionDispatcher.dispatch(
            routeResult.directToolCall!,
          );
          if (isClosed) return;
          final replyText = (actionResult.displayText != null &&
                  actionResult.displayText!.trim().isNotEmpty)
              ? actionResult.displayText!
              : 'تم تنفيذ طلبك بنجاح.';
          _finalizeBotMessage(
            text: replyText,
            sources: const [],
            isOffline: false,
            actionResults: [actionResult],
          );
          return;
        }

        final canUseOnline = await _repository.canUseOnlineAi();
        if (!canUseOnline) {
          if (isClosed) return;
          _finalizeBotMessage(
            text:
                'هذا الأمر المتقدم يحتاج إلى اتصال بالإنترنت لتنفيذه. يمكنك تنفيذ الأوامر السريعة مثل مواقيت الصلاة أو تشغيل السور أو الأذكار مباشرة.',
            sources: const [],
            isOffline: true,
          );
          return;
        }

        await _runAiStream(
          query: routeResult.cleanedQuery,
          sources: const [],
          mode: HojatyAiGenerationMode.toolOnly,
        );
        return;
      }

      // Route C: KNOWLEDGE_RAG -> RAG retrieval ONLY (0 Tool Calling)
      final canUseOnline = await _repository.canUseOnlineAi();
      debugPrint('HojatyAiCubit: canUseOnline=$canUseOnline');

      final isSingleSource =
          routeResult.route == HojatyQueryRoute.ragSingleSource;
      final maxSources = isSingleSource ? 1 : 3;
      final ragQuery = routeResult.cleanedQuery;

      if (!canUseOnline) {
        final localSources = await _repository.retrieveSources(
          ragQuery,
          maxSources: maxSources,
          singleSource: isSingleSource,
        );
        if (isClosed) return;

        if (localSources.isEmpty) {
          _finalizeBotMessage(
            text: _repository.formatNoMatchResponse(),
            sources: const [],
            isOffline: true,
          );
          return;
        }

        _finalizeBotMessage(
          text: _repository.formatOfflineResponse(localSources),
          sources: localSources,
          isOffline: true,
        );
        return;
      }

      // Online RAG Path: Semantic embedding first -> strict relevance gate
      debugPrint('HojatyAiCubit: Getting embedding (singleSource=$isSingleSource)...');
      final queryVector = await _repository.getEmbedding(ragQuery);
      List<RagChunkModel> effectiveSources;

      if (queryVector != null && queryVector.length == 512) {
        effectiveSources = await _repository.retrieveSources(
          ragQuery,
          queryVector: queryVector,
          maxSources: maxSources,
          singleSource: isSingleSource,
          allowKeywordFallback: false,
        );
      } else {
        effectiveSources = await _repository.retrieveSources(
          ragQuery,
          maxSources: maxSources,
          singleSource: isSingleSource,
        );
      }

      if (isClosed) return;

      // Relevance Gate: if no source met the threshold, skip LLM call and reply concisely
      if (effectiveSources.isEmpty) {
        debugPrint('HojatyAiCubit: No relevant sources passed threshold -> skipping LLM');
        _finalizeBotMessage(
          text: _repository.formatNoMatchResponse(),
          sources: const [],
          isOffline: false,
        );
        return;
      }

      currentWorkingSources = effectiveSources;
      emit(state.copyWith(
        currentSources: effectiveSources,
        processingStage: HojatyAiProcessingStage.generating,
      ));

      await _runAiStream(
        query: ragQuery,
        sources: effectiveSources,
        mode: isSingleSource
            ? HojatyAiGenerationMode.ragSingleSource
            : HojatyAiGenerationMode.ragMultiSource,
      );
    } catch (e, st) {
      debugPrint('HojatyAiCubit: sendMessage error: $e\n$st');
      if (!isClosed) {
        final fallbackSources = state.currentSources.isNotEmpty
            ? state.currentSources
            : currentWorkingSources;
        _finalizeBotMessage(
          text: fallbackSources.isEmpty
              ? _repository.formatNoMatchResponse()
              : _repository.formatOfflineResponse(fallbackSources),
          sources: fallbackSources,
          isOffline: true,
        );
      }
    }
  }

  Future<void> _runAiStream({
    required String query,
    required List<RagChunkModel> sources,
    required HojatyAiGenerationMode mode,
  }) async {
    final textBuffer = StringBuffer();
    final List<AiToolActionResultModel> executedActions = [];
    final List<Future<void>> pendingToolFutures = [];
    await _generationSubscription?.cancel();

    final completer = Completer<void>();

    _generationSubscription = _repository
        .generateAnswerStream(
          userMessage: query,
          sources: sources,
          mode: mode,
        )
        .listen(
      (chunk) {
        if (isClosed) return;
        if (chunk.hasText) {
          textBuffer.write(chunk.text!);
          emit(state.copyWith(
            currentStreamingText: textBuffer.toString(),
          ));
        }

        if (chunk.hasToolCall && mode == HojatyAiGenerationMode.toolOnly) {
          debugPrint('HojatyAiCubit: executing tool ${chunk.toolCall!.name}');
          final future = _actionDispatcher.dispatch(chunk.toolCall!).then((result) {
            if (isClosed) return;
            executedActions.add(result);
            if (result.displayText != null && textBuffer.isEmpty) {
              textBuffer.write(result.displayText);
              emit(state.copyWith(
                currentStreamingText: textBuffer.toString(),
              ));
            }
          });
          pendingToolFutures.add(future);
        }
      },
      onError: (err) async {
        debugPrint('HojatyAiCubit: Generation stream error: $err');
        if (pendingToolFutures.isNotEmpty) {
          await Future.wait(pendingToolFutures);
        }
        if (!isClosed) {
          final finalSources =
              executedActions.isNotEmpty ? const <RagChunkModel>[] : sources;
          _finalizeBotMessage(
            text: textBuffer.isNotEmpty
                ? textBuffer.toString()
                : _repository.formatOfflineResponse(finalSources),
            sources: finalSources,
            isOffline: true,
            actionResults: executedActions,
          );
        }
        if (!completer.isCompleted) completer.complete();
      },
      onDone: () async {
        if (pendingToolFutures.isNotEmpty) {
          await Future.wait(pendingToolFutures);
        }
        debugPrint(
          'HojatyAiCubit: Generation stream done (buffer length=${textBuffer.length})',
        );
        if (!isClosed) {
          final fullText = textBuffer.toString().trim();
          final finalSources =
              executedActions.isNotEmpty ? const <RagChunkModel>[] : sources;
          final isOfflineResponse = fullText.isEmpty ||
              fullText.startsWith('تعذر الاتصال بالخادم') ||
              fullText.startsWith('أقرب النصوص الموثقة');

          _finalizeBotMessage(
            text: fullText.isNotEmpty
                ? fullText
                : (executedActions.isNotEmpty
                    ? 'تم تنفيذ طلبك بنجاح.'
                    : _repository.formatOfflineResponse(finalSources)),
            sources: finalSources,
            isOffline: isOfflineResponse,
            actionResults: executedActions,
          );
        }
        if (!completer.isCompleted) completer.complete();
      },
      cancelOnError: false,
    );

    await completer.future;
  }

  void _finalizeBotMessage({
    required String text,
    required List<RagChunkModel> sources,
    required bool isOffline,
    List<AiToolActionResultModel> actionResults = const [],
  }) {
    final botMessage = ChatMessageModel(
      id: '${DateTime.now().microsecondsSinceEpoch}_bot',
      text: text.trim(),
      sender: MessageSender.ai,
      timestamp: DateTime.now(),
      sources: sources,
      actionResults: actionResults,
      isOffline: isOffline,
    );

    final updatedMessages = [...state.messages, botMessage];
    emit(state.copyWith(
      status: HojatyAiStatus.success,
      messages: updatedMessages,
      isStreaming: false,
      processingStage: HojatyAiProcessingStage.idle,
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
    if (state.isStreaming) {
      final fallbackSources = state.currentSources;
      final text = state.currentStreamingText.isNotEmpty
          ? state.currentStreamingText
          : _repository.formatOfflineResponse(fallbackSources);
      final botMessage = ChatMessageModel(
        id: '${DateTime.now().microsecondsSinceEpoch}_bot',
        text: text.trim(),
        sender: MessageSender.ai,
        timestamp: DateTime.now(),
        sources: fallbackSources,
        isOffline: true,
      );
      _persistMessages([...state.messages, botMessage]);
    }
    _generationSubscription?.cancel();
    _downloadSubscription?.cancel();
    return super.close();
  }
}

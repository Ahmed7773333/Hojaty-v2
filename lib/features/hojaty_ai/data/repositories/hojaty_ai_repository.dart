import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:hojaty/features/hojaty_ai/data/datasources/gemini_key_pool.dart';
import 'package:hojaty/features/hojaty_ai/data/datasources/hojaty_tool_registry.dart';
import 'package:hojaty/features/hojaty_ai/data/datasources/rag_database_service.dart';
import 'package:hojaty/features/hojaty_ai/data/models/ai_tool_call_model.dart';
import 'package:hojaty/features/hojaty_ai/data/models/hojaty_ai_stream_chunk.dart';
import 'package:hojaty/features/hojaty_ai/data/models/rag_chunk_model.dart';
import 'package:hojaty/features/hojaty_ai/domain/services/hojaty_query_router.dart';

/// Controls prompt style, token budget, and whether tool declarations are attached.
enum HojatyAiGenerationMode {
  /// Focused single-source lookup: concise, direct, 0 tools attached.
  ragSingleSource,

  /// Multi-angle or empathetic RAG answer (1..3 filtered sources): structured, concise, 0 tools attached.
  ragMultiSource,

  /// Pure app-command execution: tools attached, 0 RAG sources, minimal confirmation text.
  toolOnly,
}

class HojatyAiRepository {
  final Dio _dio;
  final GeminiKeyPool _keyPool;
  final RagDatabaseService _ragDbService;

  static const String _singleSourceInstruction = '''
أنت "مساعد حجتي الذكي" (تطبيق إسلامي).
قواعد الرد الصارمة:
1. أجب بشكل مباشر وواضح ومختصر جداً (في سطرين إلى 4 أسطر كحد أقصى إلا إذا كان النص الشرعي نفسه طويلاً).
2. ممنوع المقدمات الطويلة أو الإطالة أو تكرار السؤال أو الحشو.
3. اعتمد حصرياً على [المصدر الشرعي المرفق] ولا تؤلف أو تستدعِ أي آية أو حديث أو مرجع من خارج النص المرفق.
4. اذكر المرجع بدقة بين قوسين كما ورد، مثل: (سورة البقرة - آية 255).
5. إذا كان المصدر المرفق لا يجيب على السؤال فعلياً، قل باختصار: "عذراً، لم أجد في المصادر المتاحة إجابة مباشرة لهذا السؤال." دون إطالة.
''';

  static const String _multiSourceInstruction = '''
أنت "مساعد حجتي الذكي" (تطبيق إسلامي).
قواعد الرد الصارمة:
1. كن موجزاً ومنظماً وواضحاً؛ تجنب الرغي والمقدمات الإنشائية الطويلة.
2. إذا ذكر المستخدم موقفاً شخصياً أو ضيقاً، ابدأ بجملة مواساة دافئة واحدة فقط، ثم انتقل مباشرةً للنص الشرعي الأنسب.
3. اعتمد حصرياً على قسم [المصادر الشرعية المستخرجة] المرفق بالأسفل. يمنع منعاً باتاً تأليف أو استدعاء أي آية أو حديث أو مرجع من خارج النصوص المرفقة.
4. لا تُجبر نفسك على استخدام كل المصادر المرفقة؛ اختر فقط النص أو النصين الأكثر صلة بسؤال المستخدم، واذكر المرجع بدقة بين قوسين.
5. إذا لم تكن المصادر المرفقة ذات صلة حقيقية بالسؤال، اعتذر في سطر واحد: "عذراً، لم أجد في المصادر المتاحة نصاً مباشراً يجيب على سؤالك."
''';

  static const String _toolOnlyInstruction = '''
أنت "مساعد حجتي الذكي" لتنفيذ أوامر التطبيق.
مهمتك:
1. استدعِ الأداة المناسبة فوراً لتنفيذ أمر المستخدم بالمعاملات الدقيقة.
2. لا تكتب شروحات طويلة ولا تذكر نصوصاً شرعية غير مطلوبة؛ اكتفِ بجملة تأكيد قصيرة وواضحة بعد تنفيذ الأمر.
3. إذا كان الأمر غير مدعوم بالأدوات المتاحة، أخبر المستخدم بذلك باختصار في سطر واحد.
''';

  /// Models available in Free Tier, ordered by speed and quota friendliness
  static const List<String> _fallbackRestModels = [
    'gemini-3.5-flash-lite',
    'gemini-flash-latest',
    'gemini-3.5-flash',
    'gemini-3.8-flash',
  ];

  HojatyAiRepository({
    required this._dio,
    required this._keyPool,
    required this._ragDbService,
  });

  /// Fast connectivity check to determine whether online AI inference is reachable.
  Future<bool> isOnline() async {
    try {
      final result = await InternetAddress.lookup('generativelanguage.googleapis.com')
          .timeout(const Duration(milliseconds: 3500));
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (_) {
      try {
        final result = await InternetAddress.lookup('google.com')
            .timeout(const Duration(milliseconds: 2500));
        return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
      } catch (_) {
        return false;
      }
    }
  }

  /// Whether the online AI path should be used (API keys available + internet reachable).
  Future<bool> canUseOnlineAi() async {
    if (!_keyPool.hasKeys) return false;
    return await isOnline();
  }

  /// Clean, polite local reply when no relevant Islamic source passed the relevance threshold.
  String formatNoMatchResponse() {
    return 'عذراً، لم أجد نصاً شرعياً مطابقاً لسؤالك في قاعدة البيانات الحالية.\n'
        'يمكنني مساعدتك في الأسئلة الإسلامية (القرآن، التفسير، الأحاديث، الأذكار، الأدعية) أو تنفيذ أوامر التطبيق مثل مواقيت الصلاة وتشغيل القرآن والقبلة والسبحة.';
  }

  /// Formats the offline response message with grounded Islamic sources.
  String formatOfflineResponse(List<RagChunkModel> sources) {
    if (sources.isEmpty) {
      return 'تعذر الاتصال بالخادم حالياً، ولم أجد نصاً مطابقاً في قاعدة البيانات المحلية. جرّب صياغة السؤال بكلمات أوضح أو تحقق من اتصالك بالإنترنت.';
    }

    final buffer = StringBuffer();
    if (sources.length == 1) {
      final s = sources.first;
      buffer.writeln('📌 ${s.sourceTitle} (${s.reference}):');
      buffer.writeln(s.content);
      return buffer.toString().trim();
    }

    buffer.writeln('أقرب النصوص الموثقة من قاعدة بيانات التطبيق:\n');
    for (int i = 0; i < sources.length; i++) {
      final s = sources[i];
      buffer.writeln('📌 ${s.sourceTitle} (${s.reference}):');
      buffer.writeln('${s.content}\n');
    }

    return buffer.toString().trim();
  }

  /// Step A: Query Embedding via Dio (1 Request)
  /// Retries with key rotation if 429/503 occurs.
  Future<List<double>?> getEmbedding(
    String userMessage, {
    CancelToken? cancelToken,
  }) async {
    final totalKeys = _keyPool.totalKeys;
    final maxAttempts = totalKeys > 0 ? totalKeys : 1;

    for (int attempt = 0; attempt < maxAttempts; attempt++) {
      final activeKey = _keyPool.getNextKey();
      if (activeKey == null || activeKey.isEmpty) {
        break;
      }

      final url =
          'https://generativelanguage.googleapis.com/v1beta/models/gemini-embedding-2:embedContent?key=$activeKey';

      try {
        final response = await _dio.post(
          url,
          data: {
            'model': 'models/gemini-embedding-2',
            'content': {
              'parts': [
                {'text': userMessage}
              ]
            },
            'taskType': 'RETRIEVAL_QUERY',
            'outputDimensionality': 512,
          },
          options: Options(
            sendTimeout: const Duration(seconds: 3),
            receiveTimeout: const Duration(seconds: 5),
          ),
          cancelToken: cancelToken,
        );

        if (response.statusCode == 200 && response.data != null) {
          final embeddingData = response.data['embedding'];
          if (embeddingData != null && embeddingData['values'] is List) {
            final rawValues = embeddingData['values'] as List;
            return rawValues.map((v) => (v as num).toDouble()).toList();
          }
        }
      } on DioException catch (e) {
        final code = e.response?.statusCode;
        debugPrint('HojatyAiRepository: Embedding request failed ($code): ${e.message}');
        if (e.type == DioExceptionType.connectionError ||
            e.type == DioExceptionType.connectionTimeout ||
            e.error is SocketException) {
          break;
        }
        if (code == 429 || code == 503 || code == 400 || code == 401) {
          _keyPool.markCooldown(activeKey);
          continue;
        }
        break;
      } catch (e) {
        debugPrint('HojatyAiRepository: Unexpected embedding error: $e');
        break;
      }
    }

    return null;
  }

  /// Step B: Local Semantic Retrieval with adaptive relevance filtering.
  /// - In [singleSource] mode, returns at most 1 highest-scoring source.
  /// - In multi-source mode, prunes weak tail chunks based on relative score drop-off (max [maxSources], default 3).
  /// - When [queryVector] is provided and [allowKeywordFallback] is false, an empty semantic result stays empty
  ///   so off-topic queries are filtered out cleanly instead of pulling unrelated keyword rows.
  Future<List<RagChunkModel>> retrieveSources(
    String userMessage, {
    List<double>? queryVector,
    int maxSources = 3,
    double minSimilarity = 0.50,
    bool singleSource = false,
    bool allowKeywordFallback = true,
  }) async {
    if (queryVector != null && queryVector.length == 512) {
      final fetchK = singleSource ? 3 : maxSources + 1;
      final results = await _ragDbService.searchTopK(
        queryVector,
        topK: fetchK,
        minSimilarity: minSimilarity,
      );

      if (results.isEmpty) {
        if (!allowKeywordFallback) return const [];
      } else {
        return _pruneSources(
          results,
          maxSources: singleSource ? 1 : maxSources,
          singleSource: singleSource,
        );
      }
    }

    if (!allowKeywordFallback) return const [];

    return await _ragDbService.searchByKeywords(
      userMessage,
      limit: singleSource ? 1 : maxSources,
    );
  }

  /// Adaptive pruning: prevents dumping 5–6 weak chunks when 1–2 strong chunks already answer the query.
  List<RagChunkModel> _pruneSources(
    List<RagChunkModel> sortedResults, {
    required int maxSources,
    required bool singleSource,
  }) {
    if (sortedResults.isEmpty) return const [];

    final top = sortedResults.first;
    if (singleSource || maxSources <= 1) {
      return [top];
    }

    final pruned = <RagChunkModel>[top];
    // Drop tail chunks that lag significantly behind the top match
    final relativeFloor = top.similarity - 0.08;
    const secondaryMinFloor = 0.52;

    for (int i = 1; i < sortedResults.length && pruned.length < maxSources; i++) {
      final candidate = sortedResults[i];
      if (candidate.similarity >= relativeFloor &&
          candidate.similarity >= secondaryMinFloor) {
        pruned.add(candidate);
      }
    }

    return pruned;
  }

  /// Formats retrieved chunks into the prompt structure.
  String _formatSourcesSection(List<RagChunkModel> sources) {
    if (sources.isEmpty) return 'لا توجد نصوص مستخرجة.';
    final buffer = StringBuffer();
    for (int i = 0; i < sources.length; i++) {
      final s = sources[i];
      buffer.writeln(
        '${i + 1}. [${s.category}] [${s.sourceTitle}] (${s.reference})',
      );
      buffer.writeln(s.content);
      buffer.writeln();
    }
    return buffer.toString().trim();
  }

  String _systemInstructionFor(HojatyAiGenerationMode mode) {
    switch (mode) {
      case HojatyAiGenerationMode.ragSingleSource:
        return _singleSourceInstruction;
      case HojatyAiGenerationMode.ragMultiSource:
        return _multiSourceInstruction;
      case HojatyAiGenerationMode.toolOnly:
        return _toolOnlyInstruction;
    }
  }

  int _maxOutputTokensFor(HojatyAiGenerationMode mode) {
    switch (mode) {
      case HojatyAiGenerationMode.ragSingleSource:
        return 350;
      case HojatyAiGenerationMode.ragMultiSource:
        return 550;
      case HojatyAiGenerationMode.toolOnly:
        return 200;
    }
  }

  String _buildPrompt(
    String userMessage,
    List<RagChunkModel> sources,
    HojatyAiGenerationMode mode,
  ) {
    if (mode == HojatyAiGenerationMode.toolOnly) {
      return '[أمر المستخدم للتطبيق]:\n$userMessage';
    }

    final sourcesText = _formatSourcesSection(sources);
    final header = mode == HojatyAiGenerationMode.ragSingleSource
        ? '[المصدر الشرعي المرفق]:'
        : '[المصادر الشرعية المستخرجة]:';

    return '''
$header
$sourcesText

[سؤال المستخدم]:
$userMessage
''';
  }

  /// Step C: Grounded Answer or Tool-Only Generation.
  /// Strictly enforces mutual exclusion between RAG and Tool Calling:
  /// - [HojatyAiGenerationMode.toolOnly]: tools attached, 0 RAG context.
  /// - RAG modes: RAG context attached, 0 tools attached.
  Stream<HojatyAiStreamChunk> generateAnswerStream({
    required String userMessage,
    required List<RagChunkModel> sources,
    HojatyAiGenerationMode mode = HojatyAiGenerationMode.ragMultiSource,
    CancelToken? cancelToken,
  }) async* {
    final includeTools = mode == HojatyAiGenerationMode.toolOnly;
    final effectiveSources = includeTools ? const <RagChunkModel>[] : sources;
    final combinedPrompt = _buildPrompt(userMessage, effectiveSources, mode);
    final systemInstruction = _systemInstructionFor(mode);
    final maxOutputTokens = _maxOutputTokensFor(mode);

    // Tier 1: WebSocket Live API
    debugPrint('HojatyAi: Trying Tier 1 (WebSocket Live API) [mode=$mode, tools=$includeTools]...');
    bool tier1ProducedContent = false;
    try {
      await for (final chunk in _tryGenerateTier1WebSocket(
        combinedPrompt: combinedPrompt,
        systemInstruction: systemInstruction,
        includeTools: includeTools,
        maxOutputTokens: maxOutputTokens,
      )) {
        if (!includeTools && chunk.hasToolCall) continue;
        tier1ProducedContent = true;
        yield chunk;
      }
    } catch (e) {
      debugPrint('HojatyAi: Tier 1 stream error: $e');
    }

    if (tier1ProducedContent) {
      debugPrint('HojatyAi: Tier 1 succeeded');
      return;
    }

    // Tier 2: REST Fallback via Dio
    debugPrint('HojatyAi: Trying Tier 2 (REST / SSE Fallback) [mode=$mode, tools=$includeTools]...');
    bool tier2ProducedContent = false;
    try {
      await for (final chunk in _tryGenerateTier2Rest(
        combinedPrompt: combinedPrompt,
        systemInstruction: systemInstruction,
        includeTools: includeTools,
        maxOutputTokens: maxOutputTokens,
        cancelToken: cancelToken,
      )) {
        if (!includeTools && chunk.hasToolCall) continue;
        tier2ProducedContent = true;
        yield chunk;
      }
    } catch (e) {
      debugPrint('HojatyAi: Tier 2 stream error: $e');
    }

    if (tier2ProducedContent) {
      debugPrint('HojatyAi: Tier 2 succeeded');
      return;
    }

    // Tier 3: Ultimate Offline / Zero-Quota Fallback
    debugPrint('HojatyAi: Falling back to Tier 3 (Offline)');
    yield* _generateTier3Offline(userMessage, effectiveSources, mode);
  }

  /// Tier 1: Unlimited Live API via WebSocket
  Stream<HojatyAiStreamChunk> _tryGenerateTier1WebSocket({
    required String combinedPrompt,
    required String systemInstruction,
    required bool includeTools,
    required int maxOutputTokens,
  }) async* {
    final activeKey = _keyPool.getNextKey();
    if (activeKey == null || activeKey.isEmpty) return;

    final uri = Uri.parse(
      'wss://generativelanguage.googleapis.com/ws/google.ai.generativelanguage.v1alpha.GenerativeService.BidiGenerateContent?key=$activeKey',
    );

    WebSocketChannel? channel;
    final controller = StreamController<HojatyAiStreamChunk>();

    try {
      channel = WebSocketChannel.connect(uri);

      await channel.ready.timeout(
        const Duration(seconds: 4),
        onTimeout: () {
          throw TimeoutException('WebSocket connection timed out', const Duration(seconds: 4));
        },
      );

      final setupMap = <String, dynamic>{
        'model': 'models/gemini-3.5-flash',
        'generationConfig': {
          'responseModalities': ['TEXT'],
          'temperature': 0.3,
          'maxOutputTokens': maxOutputTokens,
        },
        'systemInstruction': {
          'parts': [
            {'text': systemInstruction}
          ]
        },
        if (includeTools) 'tools': HojatyToolRegistry.getGeminiToolsDeclaration(),
      };

      channel.sink.add(jsonEncode({'setup': setupMap}));

      await Future.delayed(const Duration(milliseconds: 300));

      final clientContentFrame = {
        'clientContent': {
          'turns': [
            {
              'role': 'user',
              'parts': [
                {'text': combinedPrompt}
              ]
            }
          ],
          'turnComplete': true
        }
      };

      channel.sink.add(jsonEncode(clientContentFrame));

      bool receivedAnyText = false;
      final sub = channel.stream.timeout(
        const Duration(seconds: 10),
        onTimeout: (sink) {
          debugPrint('HojatyAi: WebSocket timed out after 10s');
          sink.close();
        },
      ).listen(
        (data) {
          try {
            final Map<String, dynamic> msg = jsonDecode(data.toString());

            final setupComplete = msg['setupComplete'];
            if (setupComplete != null) {
              debugPrint('HojatyAi: WebSocket setup acknowledged');
              return;
            }

            final serverContent = msg['serverContent'];
            if (serverContent != null) {
              final modelTurn = serverContent['modelTurn'];
              if (modelTurn != null && modelTurn['parts'] is List) {
                final parts = modelTurn['parts'] as List;
                for (final part in parts) {
                  final text = part['text'] as String?;
                  if (text != null && text.isNotEmpty) {
                    receivedAnyText = true;
                    if (!controller.isClosed) {
                      controller.add(HojatyAiStreamChunk(text: text));
                    }
                  }

                  final functionCall = part['functionCall'] as Map?;
                  if (functionCall != null) {
                    final name = functionCall['name'] as String? ?? '';
                    final args = (functionCall['args'] as Map?)?.map(
                          (k, v) => MapEntry(k.toString(), v),
                        ) ??
                        const <String, dynamic>{};
                    receivedAnyText = true;
                    if (!controller.isClosed) {
                      controller.add(
                        HojatyAiStreamChunk(
                          toolCall: AiToolCallModel(
                            id: DateTime.now().millisecondsSinceEpoch.toString(),
                            name: name,
                            arguments: args,
                          ),
                        ),
                      );
                    }
                  }
                }
              }
              if (serverContent['turnComplete'] == true) {
                if (!controller.isClosed) {
                  controller.close();
                }
              }
            }
          } catch (e) {
            debugPrint('HojatyAi: Error parsing WS message: $e');
          }
        },
        onError: (err) {
          debugPrint('HojatyAi: WebSocket stream error: $err');
          if (!controller.isClosed) {
            controller.close();
          }
        },
        onDone: () {
          debugPrint('HojatyAi: WebSocket stream done (receivedText=$receivedAnyText)');
          if (!controller.isClosed) {
            controller.close();
          }
        },
        cancelOnError: true,
      );

      yield* controller.stream;
      await sub.cancel();
    } catch (e) {
      debugPrint('HojatyAi: Tier 1 WebSocket failed: $e');
      if (!controller.isClosed) {
        controller.close();
      }
    } finally {
      try {
        await channel?.sink.close();
      } catch (_) {}
    }
  }

  /// Tier 2: Secondary - High-Quota REST / SSE Streaming via Dio (Optimized for Free Tier)
  Stream<HojatyAiStreamChunk> _tryGenerateTier2Rest({
    required String combinedPrompt,
    required String systemInstruction,
    required bool includeTools,
    required int maxOutputTokens,
    CancelToken? cancelToken,
  }) async* {
    bool networkUnreachable = false;

    for (final model in _fallbackRestModels) {
      if (networkUnreachable) break;

      final totalKeys = _keyPool.totalKeys;
      final maxAttempts = totalKeys > 0 ? totalKeys : 1;

      for (int attempt = 0; attempt < maxAttempts; attempt++) {
        final activeKey = _keyPool.getNextKey();
        if (activeKey == null || activeKey.isEmpty) break;

        final requestData = <String, dynamic>{
          'systemInstruction': {
            'parts': [
              {'text': systemInstruction}
            ]
          },
          'contents': [
            {
              'role': 'user',
              'parts': [
                {'text': combinedPrompt}
              ]
            }
          ],
          if (includeTools) 'tools': HojatyToolRegistry.getGeminiToolsDeclaration(),
          'generationConfig': {
            'temperature': 0.3,
            'maxOutputTokens': maxOutputTokens,
          }
        };

        // 1. Try real-time SSE streaming first
        final sseUrl =
            'https://generativelanguage.googleapis.com/v1beta/models/$model:streamGenerateContent?alt=sse&key=$activeKey';
        bool sseProducedAny = false;

        try {
          debugPrint('HojatyAi: Tier 2 trying SSE ($model) (attempt ${attempt + 1})');
          final response = await _dio.post<ResponseBody>(
            sseUrl,
            data: requestData,
            options: Options(
              responseType: ResponseType.stream,
              headers: {'Accept': 'text/event-stream'},
              sendTimeout: const Duration(seconds: 4),
              receiveTimeout: const Duration(seconds: 15),
            ),
            cancelToken: cancelToken,
          );

          if (response.statusCode == 200 && response.data != null) {
            String leftover = '';
            await for (final rawBytes in response.data!.stream) {
              final textChunk = utf8.decode(rawBytes, allowMalformed: true);
              final lines = (leftover + textChunk).split('\n');
              leftover = lines.removeLast();

              for (final line in lines) {
                final trimmed = line.trim();
                if (trimmed.startsWith('data:')) {
                  final jsonStr = trimmed.substring(5).trim();
                  if (jsonStr.isNotEmpty) {
                    try {
                      final Map<String, dynamic> data = jsonDecode(jsonStr);
                      final candidates = data['candidates'] as List?;
                      if (candidates != null && candidates.isNotEmpty) {
                        final content = candidates[0]['content'];
                        final parts = content?['parts'] as List?;
                        if (parts != null && parts.isNotEmpty) {
                          for (final part in parts) {
                            final text = part['text'] as String?;
                            if (text != null && text.isNotEmpty) {
                              sseProducedAny = true;
                              yield HojatyAiStreamChunk(text: text);
                            }

                            final functionCall = part['functionCall'] as Map?;
                            if (functionCall != null) {
                              final name = functionCall['name'] as String? ?? '';
                              final args = (functionCall['args'] as Map?)?.map(
                                    (k, v) => MapEntry(k.toString(), v),
                                  ) ??
                                  const <String, dynamic>{};
                              sseProducedAny = true;
                              yield HojatyAiStreamChunk(
                                toolCall: AiToolCallModel(
                                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                                  name: name,
                                  arguments: args,
                                ),
                              );
                            }
                          }
                        }
                      }
                    } catch (_) {}
                  }
                }
              }
            }

            if (sseProducedAny) {
              debugPrint('HojatyAi: Tier 2 SSE ($model) completed successfully');
              return;
            }
          }
        } on DioException catch (e) {
          final code = e.response?.statusCode;
          debugPrint('HojatyAi: Tier 2 SSE ($model) failed with code $code: ${e.message}');
          if (e.type == DioExceptionType.connectionError ||
              e.type == DioExceptionType.connectionTimeout ||
              e.error is SocketException) {
            networkUnreachable = true;
            break;
          }
          if (code == 429 || code == 503 || code == 400 || code == 401) {
            _keyPool.markCooldown(activeKey);
            continue;
          }
        } catch (e) {
          debugPrint('HojatyAi: Tier 2 SSE ($model) error: $e');
        }

        if (networkUnreachable) break;

        // 2. Fallback to standard generateContent if SSE produced nothing
        final regularUrl =
            'https://generativelanguage.googleapis.com/v1beta/models/$model:generateContent?key=$activeKey';

        try {
          debugPrint('HojatyAi: Tier 2 trying standard POST ($model)');
          final response = await _dio.post(
            regularUrl,
            data: requestData,
            options: Options(
              sendTimeout: const Duration(seconds: 4),
              receiveTimeout: const Duration(seconds: 15),
            ),
            cancelToken: cancelToken,
          );

          if (response.statusCode == 200 && response.data != null) {
            final candidates = response.data['candidates'] as List?;
            if (candidates != null && candidates.isNotEmpty) {
              final content = candidates[0]['content'];
              final parts = content?['parts'] as List?;
              if (parts != null && parts.isNotEmpty) {
                for (final part in parts) {
                  final text = part['text'] as String?;
                  if (text != null && text.isNotEmpty) {
                    debugPrint('HojatyAi: Tier 2 standard $model succeeded (${text.length} chars)');
                    yield HojatyAiStreamChunk(text: text);
                  }

                  final functionCall = part['functionCall'] as Map?;
                  if (functionCall != null) {
                    final name = functionCall['name'] as String? ?? '';
                    final args = (functionCall['args'] as Map?)?.map(
                          (k, v) => MapEntry(k.toString(), v),
                        ) ??
                        const <String, dynamic>{};
                    yield HojatyAiStreamChunk(
                      toolCall: AiToolCallModel(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        name: name,
                        arguments: args,
                      ),
                    );
                  }
                }
                return;
              }
            }
          }
        } on DioException catch (e) {
          final code = e.response?.statusCode;
          debugPrint('HojatyAi: Tier 2 standard ($model) failed with code $code: ${e.message}');
          if (e.type == DioExceptionType.connectionError ||
              e.type == DioExceptionType.connectionTimeout ||
              e.error is SocketException) {
            networkUnreachable = true;
            break;
          }
          if (code == 429 || code == 503 || code == 400 || code == 401) {
            _keyPool.markCooldown(activeKey);
            continue;
          }
          break;
        } catch (e) {
          debugPrint('HojatyAi: Tier 2 standard ($model) unexpected error: $e');
          break;
        }
      }
    }
  }

  /// Tier 3: Ultimate Offline / Zero-Quota Fallback
  Stream<HojatyAiStreamChunk> _generateTier3Offline(
    String userMessage,
    List<RagChunkModel> sources,
    HojatyAiGenerationMode mode,
  ) async* {
    if (mode == HojatyAiGenerationMode.toolOnly) {
      final offlineTool = matchOfflineToolIntent(userMessage);
      if (offlineTool != null) {
        yield HojatyAiStreamChunk(toolCall: offlineTool);
        return;
      }
      yield const HojatyAiStreamChunk(
        text: 'تعذر تنفيذ هذا الأمر حالياً لعدم توفر اتصال بالخادم. يرجى المحاولة لاحقاً.',
      );
      return;
    }

    yield HojatyAiStreamChunk(text: formatOfflineResponse(sources));
  }

  /// Delegates local deterministic tool intent matching to [HojatyQueryRouter].
  AiToolCallModel? matchOfflineToolIntent(String userMessage) {
    final norm = HojatyQueryRouter.normalizeArabic(userMessage);
    return HojatyQueryRouter.matchDirectToolCommand(norm);
  }
}

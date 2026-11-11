import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../datasources/gemini_key_pool.dart';
import '../datasources/rag_database_service.dart';
import '../models/rag_chunk_model.dart';

class HojatyAiRepository {
  final Dio _dio;
  final GeminiKeyPool _keyPool;
  final RagDatabaseService _ragDbService;

  static const String _systemInstruction = '''
أنت "المساعد الإسلامي الذكي" في تطبيق (حجتي).
مهمتك:
1. إذا كان المستخدم يحكي موقفاً شخصياً أو ضيقاً أو مشكلة حياتية، ابدأ بمواساته والتفاعل معه بلطف وحكمة، واربط موقفه بالنصوص الشرعية المستخرجة له (قرآن وتفسير، أحاديث، أذكار، أدعية، قصص الأنبياء، أسماء الله الحسنى).
2. إذا كان يسأل سؤالاً مباشراً، أجب بوضوح وتنظيم.
3. القاعدة الذهبية الصارمة: اعتمد حصرياً في الاستشهاد بالآيات والأحاديث والأدعية والتفاسير على قسم [المصادر الشرعية المستخرجة] المرفق لك بالأسفل. يمنع منعاً باتاً تأليف أو استدعاء أي آية أو حديث أو رقم مرجع من خارج هذه النصوص المرفقة.
4. عند ذكر أي آية أو حديث أو ذكر، اكتب بعده مصدره الدقيق كما ورد بين الأقواس مثل: (سورة البقرة - آية 286) أو (صحيح البخاري - حديث رقم ...).
5. إذا كانت المصادر المرفقة لا علاقة لها بسؤال السائل إطلاقاً، اعتذر بلطف وقل: "عذراً، لم أجد في المصادر المتاحة حالياً نصاً مباشراً يجيب على هذا التفصيل، وهذه أقرب النصوص ذات الصلة:".
''';

  /// Models available in Free Tier, ordered by speed and quota friendliness
  static const List<String> _fallbackRestModels = [
    'gemini-3.5-flash-lite',
    'gemini-flash-latest',
    'gemini-3.5-flash',
    'gemini-3.8-flash',
  ];

  HojatyAiRepository({
    required Dio dio,
    required GeminiKeyPool keyPool,
    required RagDatabaseService ragDbService,
  })  : _dio = dio,
        _keyPool = keyPool,
        _ragDbService = ragDbService;

  /// Step A: Query Context Expansion & Embedding via Dio (1 Request)
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

      final url = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-embedding-2:embedContent?key=$activeKey';

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

  /// Step B: Local Semantic Retrieval
  /// Uses cosine vector similarity on SQLite chunks; falls back to keyword search if vector is null or empty.
  Future<List<RagChunkModel>> retrieveSources(
    String userMessage, {
    List<double>? queryVector,
  }) async {
    if (queryVector != null && queryVector.length == 512) {
      final results = await _ragDbService.searchTopK(
        queryVector,
        topK: 6,
        minSimilarity: 0.40,
      );
      if (results.isNotEmpty) {
        return results;
      }
    }

    // Fallback to keyword search in local DB
    return await _ragDbService.searchByKeywords(userMessage, limit: 6);
  }

  /// Formats retrieved chunks into the prompt structure
  String _formatSourcesSection(List<RagChunkModel> sources) {
    if (sources.isEmpty) return 'لا توجد نصوص مستخرجة.';
    final buffer = StringBuffer();
    for (int i = 0; i < sources.length; i++) {
      final s = sources[i];
      buffer.writeln('${i + 1}. [التصنيف: ${s.category}] [المصدر: ${s.sourceTitle}] [المرجع: ${s.reference}]');
      buffer.writeln('النص: ${s.content}');
      buffer.writeln();
    }
    return buffer.toString().trim();
  }

  String _buildCombinedPrompt(String userMessage, List<RagChunkModel> sources) {
    final sourcesText = _formatSourcesSection(sources);
    return '''
[المصادر الشرعية المستخرجة من قاعدة البيانات]:
$sourcesText

[سؤال المستخدم أو الموقف الحياتي]:
$userMessage
''';
  }

  /// Step C: Empathetic & Strictly Grounded Answer Generation
  /// Tries Generation Tier 1 (WebSocket Live API), falls back to Tier 2 (Dio REST),
  /// and ultimately Tier 3 (Offline structured local response).
  Stream<String> generateAnswerStream({
    required String userMessage,
    required List<RagChunkModel> sources,
    CancelToken? cancelToken,
  }) async* {
    final combinedPrompt = _buildCombinedPrompt(userMessage, sources);

    // Tier 1: WebSocket Live API
    debugPrint('HojatyAi: Trying Tier 1 (WebSocket Live API)...');
    bool tier1ProducedContent = false;
    try {
      await for (final chunk in _tryGenerateTier1WebSocket(combinedPrompt)) {
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
    debugPrint('HojatyAi: Trying Tier 2 (REST / SSE Fallback)...');
    bool tier2ProducedContent = false;
    try {
      await for (final chunk in _tryGenerateTier2Rest(
        combinedPrompt: combinedPrompt,
        cancelToken: cancelToken,
      )) {
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
    yield* _generateTier3Offline(sources);
  }

  /// Tier 1: Unlimited Live API via WebSocket
  Stream<String> _tryGenerateTier1WebSocket(String combinedPrompt) async* {
    final activeKey = _keyPool.getNextKey();
    if (activeKey == null || activeKey.isEmpty) return;

    final uri = Uri.parse(
      'wss://generativelanguage.googleapis.com/ws/google.ai.generativelanguage.v1alpha.GenerativeService.BidiGenerateContent?key=$activeKey',
    );

    WebSocketChannel? channel;
    final controller = StreamController<String>();

    try {
      channel = WebSocketChannel.connect(uri);

      // Wait for the WebSocket to be ready (catches connection failures early)
      await channel.ready.timeout(
        const Duration(seconds: 4),
        onTimeout: () {
          throw TimeoutException('WebSocket connection timed out', const Duration(seconds: 4));
        },
      );

      // Send initial setup frame
      final setupFrame = {
        'setup': {
          'model': 'models/gemini-3.5-flash',
          'generationConfig': {
            'responseModalities': ['TEXT']
          },
          'systemInstruction': {
            'parts': [
              {'text': _systemInstruction}
            ]
          }
        }
      };

      channel.sink.add(jsonEncode(setupFrame));

      // Wait briefly for setup acknowledgement before sending content
      await Future.delayed(const Duration(milliseconds: 300));

      // Send clientContent
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

            // Check for setup completion acknowledgement
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
                      controller.add(text);
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
  Stream<String> _tryGenerateTier2Rest({
    required String combinedPrompt,
    CancelToken? cancelToken,
  }) async* {
    for (final model in _fallbackRestModels) {
      final totalKeys = _keyPool.totalKeys;
      final maxAttempts = totalKeys > 0 ? totalKeys : 1;

      for (int attempt = 0; attempt < maxAttempts; attempt++) {
        final activeKey = _keyPool.getNextKey();
        if (activeKey == null || activeKey.isEmpty) break;

        final requestData = {
          'systemInstruction': {
            'parts': [
              {'text': _systemInstruction}
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
          'generationConfig': {
            'temperature': 0.4,
          }
        };

        // 1. Try real-time SSE streaming first for instant token-by-token output
        final sseUrl = 'https://generativelanguage.googleapis.com/v1beta/models/$model:streamGenerateContent?alt=sse&key=$activeKey';
        bool sseProducedAny = false;

        try {
          debugPrint('HojatyAi: Tier 2 trying SSE ($model) (attempt ${attempt + 1})');
          final response = await _dio.post<ResponseBody>(
            sseUrl,
            data: requestData,
            options: Options(
              responseType: ResponseType.stream,
              headers: {'Accept': 'text/event-stream'},
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
                              yield text;
                            }
                          }
                        }
                      }
                    } catch (_) {}
                  }
                }
              }
            }
          }

          if (sseProducedAny) {
            debugPrint('HojatyAi: Tier 2 SSE ($model) completed successfully');
            return;
          }
        } on DioException catch (e) {
          final code = e.response?.statusCode;
          debugPrint('HojatyAi: Tier 2 SSE ($model) failed with code $code: ${e.message}');
          if (code == 429 || code == 503 || code == 400 || code == 401) {
            _keyPool.markCooldown(activeKey);
            continue;
          }
        } catch (e) {
          debugPrint('HojatyAi: Tier 2 SSE ($model) error: $e');
        }

        // 2. Fallback to standard generateContent if SSE produced nothing
        final regularUrl = 'https://generativelanguage.googleapis.com/v1beta/models/$model:generateContent?key=$activeKey';

        try {
          debugPrint('HojatyAi: Tier 2 trying standard POST ($model)');
          final response = await _dio.post(
            regularUrl,
            data: requestData,
            cancelToken: cancelToken,
          );

          if (response.statusCode == 200 && response.data != null) {
            final candidates = response.data['candidates'] as List?;
            if (candidates != null && candidates.isNotEmpty) {
              final content = candidates[0]['content'];
              final parts = content?['parts'] as List?;
              if (parts != null && parts.isNotEmpty) {
                final text = parts[0]['text'] as String?;
                if (text != null && text.isNotEmpty) {
                  debugPrint('HojatyAi: Tier 2 standard $model succeeded (${text.length} chars)');
                  yield text;
                  return;
                }
              }
            }
          }
        } on DioException catch (e) {
          final code = e.response?.statusCode;
          debugPrint('HojatyAi: Tier 2 standard ($model) failed with code $code: ${e.message}');
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
  Stream<String> _generateTier3Offline(List<RagChunkModel> sources) async* {
    if (sources.isEmpty) {
      yield 'أهلاً بك. تعذر الاتصال بالخادم الذكي في الوقت الحالي، ولم يتم العثور على مصادر مطابقة في قاعدة البيانات المحلية. يرجى التأكد من اتصالك بالإنترنت وإعادة المحاولة.';
      return;
    }

    final buffer = StringBuffer();
    buffer.writeln('أهلاً بك. تعذر الاتصال بالخادم في الوقت الحالي، ولكن إليك أهم النصوص الشرعية الموثقة المستخرجة مباشرة من قاعدة بيانات التطبيق المتعلقة بما سألت عنه:\n');

    for (int i = 0; i < sources.length; i++) {
      final s = sources[i];
      buffer.writeln('📌 ${s.sourceTitle} (${s.reference}):');
      buffer.writeln('${s.content}\n');
    }

    yield buffer.toString().trim();
  }
}

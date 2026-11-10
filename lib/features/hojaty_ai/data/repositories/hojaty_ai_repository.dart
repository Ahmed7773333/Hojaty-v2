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

  static const List<String> _fallbackRestModels = [
    'gemini-2.5-flash',
    'gemma-4-31b-it',
    'gemma-4-26b-it',
    'gemini-1.5-flash',
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

      final url = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-embedding-001:embedContent?key=$activeKey';

      try {
        final response = await _dio.post(
          url,
          data: {
            'model': 'models/gemini-embedding-001',
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
    final wsStream = _tryGenerateTier1WebSocket(combinedPrompt);
    bool tier1ProducedContent = false;

    await for (final chunk in wsStream) {
      tier1ProducedContent = true;
      yield chunk;
    }

    if (tier1ProducedContent) {
      return;
    }

    // Tier 2: REST Fallback via Dio
    final restStream = _tryGenerateTier2Rest(
      combinedPrompt: combinedPrompt,
      cancelToken: cancelToken,
    );
    bool tier2ProducedContent = false;

    await for (final chunk in restStream) {
      tier2ProducedContent = true;
      yield chunk;
    }

    if (tier2ProducedContent) {
      return;
    }

    // Tier 3: Ultimate Offline / Zero-Quota Fallback
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
    StreamController<String>? controller;

    try {
      channel = WebSocketChannel.connect(uri);
      controller = StreamController<String>();

      // Send initial setup frame
      final setupFrame = {
        'setup': {
          'model': 'models/gemini-2.5-flash-native-audio-dialog',
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
        const Duration(seconds: 8),
        onTimeout: (sink) {
          sink.close();
        },
      ).listen(
        (data) {
          try {
            final Map<String, dynamic> msg = jsonDecode(data.toString());
            final serverContent = msg['serverContent'];
            if (serverContent != null) {
              final modelTurn = serverContent['modelTurn'];
              if (modelTurn != null && modelTurn['parts'] is List) {
                final parts = modelTurn['parts'] as List;
                for (final part in parts) {
                  final text = part['text'] as String?;
                  if (text != null && text.isNotEmpty) {
                    receivedAnyText = true;
                    controller?.add(text);
                  }
                }
              }
              if (serverContent['turnComplete'] == true) {
                controller?.close();
              }
            }
          } catch (_) {}
        },
        onError: (err) {
          _keyPool.markCooldown(activeKey);
          controller?.close();
        },
        onDone: () {
          if (!receivedAnyText) {
            _keyPool.markCooldown(activeKey);
          }
          controller?.close();
        },
        cancelOnError: true,
      );

      yield* controller.stream;
      await sub.cancel();
    } catch (e) {
      _keyPool.markCooldown(activeKey);
      debugPrint('Tier 1 WebSocket failed: $e');
    } finally {
      try {
        await channel?.sink.close();
      } catch (_) {}
    }
  }

  /// Tier 2: Secondary - High-Quota REST Fallback via Dio
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

        final url = 'https://generativelanguage.googleapis.com/v1beta/models/$model:generateContent?key=$activeKey';

        try {
          final response = await _dio.post(
            url,
            data: {
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
            },
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
                  yield text;
                  return;
                }
              }
            }
          }
        } on DioException catch (e) {
          final code = e.response?.statusCode;
          debugPrint('Tier 2 REST ($model) failed with code $code: ${e.message}');
          if (code == 429 || code == 503 || code == 400 || code == 401) {
            _keyPool.markCooldown(activeKey);
            continue;
          }
          break;
        } catch (e) {
          debugPrint('Tier 2 REST ($model) unexpected error: $e');
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


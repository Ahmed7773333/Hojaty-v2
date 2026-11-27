import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:hojaty/features/hojaty_ai/data/datasources/hojaty_tool_registry.dart';
import 'package:hojaty/features/hojaty_ai/domain/services/hojaty_query_router.dart';
import 'package:hojaty/features/hojaty_ai/domain/services/hojaty_starter_prompts_provider.dart';
import 'package:hojaty/l10n/app_localizations_ar.dart';
import 'package:hojaty/l10n/app_localizations_en.dart';

void main() {
  debugPrint('=== Running Hojaty AI Router & Registry Self-Check ===');

  // 1. Live Stream Tool & Parameters must be completely removed
  final toolsJson = jsonEncode(HojatyToolRegistry.getGeminiToolsDeclaration());
  assert(!toolsJson.contains('isLiveStream'), 'isLiveStream must be removed');
  assert(!toolsJson.contains('streamType'), 'streamType must be removed');
  assert(!toolsJson.contains('live_stream'), 'live_stream must be removed');
  debugPrint('✓ Live stream tool parameters removed from HojatyToolRegistry');

  // 2. NO_OP: Gibberish, numbers, keyboard mash, chitchat, off-topic, live stream
  const noOpInputs = [
    'asdf',
    '12345',
    'هههههه',
    'ضصثقفغ',
    'qwerty',
    'السلام عليكم',
    'hello',
    'thanks',
    'احكيلي نكته',
    'شغل بث مكة المباشر',
    'play makkah live stream',
  ];
  for (final input in noOpInputs) {
    final res = HojatyQueryRouter.route(input);
    assert(
      res.intent == HojatyIntent.noOp,
      'Expected noOp for "$input", got ${res.intent}',
    );
    assert(
      res.instantReply != null && res.instantReply!.isNotEmpty,
      'Expected non-empty instantReply for "$input"',
    );
  }
  debugPrint('✓ NO_OP routing & bilingual replies passed');

  // 3. ACTION_TOOL: Direct and AI app commands (never RAG)
  const actionInputs = [
    'مواقيت الصلاة اليوم',
    'شغل سورة الكهف',
    'افتح أذكار الصباح',
    'تصفير السبحة',
    'اتجاه القبلة',
    'فعل تنبيه صلاة الفجر',
    'فعل الوضع الليلي',
    'prayer times today',
    'open qibla',
  ];
  for (final input in actionInputs) {
    final res = HojatyQueryRouter.route(input);
    assert(
      res.intent == HojatyIntent.actionTool,
      'Expected actionTool for "$input", got ${res.intent}',
    );
  }
  debugPrint('✓ ACTION_TOOL routing passed');

  // 4. KNOWLEDGE_RAG: Islamic questions (never hijacked by tools)
  const ragInputs = [
    'ما حكم صلاة الوتر؟',
    'ما تفسير آية الكرسي؟',
    'أشعر بضيق وهم ماذا أفعل؟',
    'دعاء تفريج الكرب',
    'what is the ruling on fasting Mondays?',
  ];
  for (final input in ragInputs) {
    final res = HojatyQueryRouter.route(input);
    assert(
      res.intent == HojatyIntent.knowledgeRag,
      'Expected knowledgeRag for "$input", got ${res.intent}',
    );
  }
  debugPrint('✓ KNOWLEDGE_RAG routing passed');

  // 5. Context-aware starter prompts (Arabic & English, Friday vs Weekday)
  final fridayMorning = DateTime(2026, 11, 20, 9); // Friday
  assert(fridayMorning.weekday == DateTime.friday);
  final arFridayPrompts = HojatyStarterPromptsProvider.getPrompts(
    AppLocalizationsAr(),
    now: fridayMorning,
  );
  assert(arFridayPrompts.length == 4, 'Expected 4 starter prompts');
  assert(
    arFridayPrompts.first.prompt.contains('الكهف'),
    'Friday morning should suggest Surah Al-Kahf',
  );

  final enEvening = DateTime(2026, 11, 24, 18); // Tuesday evening
  final enEveningPrompts = HojatyStarterPromptsProvider.getPrompts(
    AppLocalizationsEn(),
    now: enEvening,
  );
  assert(enEveningPrompts.length == 4, 'Expected 4 English starter prompts');
  assert(
    enEveningPrompts.first.prompt.toLowerCase().contains('evening'),
    'Evening should suggest Evening Athkar',
  );
  debugPrint('✓ Context-aware starter prompts passed');

  debugPrint('=== ALL HOJATY AI ROUTER CHECKS PASSED ===');
}

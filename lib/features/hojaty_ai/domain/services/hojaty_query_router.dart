import 'package:hojaty/features/hojaty_ai/data/datasources/hojaty_tool_registry.dart';
import 'package:hojaty/features/hojaty_ai/data/models/ai_tool_call_model.dart';
import 'package:hojaty/features/quran/constants/quran_constants.dart';

/// Top-level mutually exclusive 3-way intent classification.
enum HojatyIntent {
  /// Gibberish, random noise, greetings, thanks, or off-topic chitchat -> 0 RAG, 0 Tools.
  noOp,

  /// Explicit in-app action -> Tool Calling ONLY, 0 RAG.
  actionTool,

  /// Islamic knowledge question -> RAG retrieval ONLY, 0 Tools.
  knowledgeRag,
}

/// Detailed execution sub-route within the 3-way [HojatyIntent].
enum HojatyQueryRoute {
  /// Empty, gibberish, symbols, or test noise — reply locally, 0 RAG, 0 AI.
  invalidOrNoise,

  /// Pure greeting, thanks, capability question, or off-topic chitchat — reply locally, 0 RAG, 0 AI.
  chitchat,

  /// Unambiguous app command parsed locally — execute tool directly, 0 RAG, 0 AI.
  directToolCommand,

  /// Complex app command needing LLM parameter extraction — Tool Calling ONLY, 0 RAG.
  aiToolCommand,

  /// Specific factual/text lookup (single ayah, dua, hadith, meaning) — Top 1 RAG source + concise reply.
  ragSingleSource,

  /// Broad thematic, multi-angle, or personal/emotional query — Adaptive 1..3 RAG sources + concise structured reply.
  ragMultiSource,
}

class HojatyRouteResult {
  final HojatyIntent intent;
  final HojatyQueryRoute route;

  /// Immediate local response for [HojatyIntent.noOp].
  final String? instantReply;

  /// Direct tool call for [HojatyQueryRoute.directToolCommand].
  final AiToolCallModel? directToolCall;

  /// Cleaned query string (with leading greetings/filler trimmed) for RAG/AI.
  final String cleanedQuery;

  const HojatyRouteResult({
    required this.intent,
    required this.route,
    required this.cleanedQuery,
    this.instantReply,
    this.directToolCall,
  });
}

/// Fast local pre-execution intent gate & router for Hojaty AI.
/// Guarantees strict mutual exclusion between NO_OP, ACTION_TOOL, and KNOWLEDGE_RAG.
class HojatyQueryRouter {
  const HojatyQueryRouter();

  static const Set<String> _noiseWords = {
    'تست',
    'تجربه',
    'تجريب',
    'اختبار',
    'بلا بلا',
    'هلاوس',
    'test',
    'testing',
    'asdf',
    'asdfg',
    'asdfgh',
    'asdfghjkl',
    'qwerty',
    'qwert',
    'zxcv',
    'zxcvbn',
    'aaa',
    'aaaa',
    'abc',
    'abcd',
    'xyz',
    'foo',
    'bar',
    'هه',
    'ههه',
    'هههه',
    'ههههه',
    'لول',
    'lol',
    'lmao',
    'xd',
    '...',
  };

  static const Set<String> _greetingPhrases = {
    'السلام عليكم',
    'السلام عليكم ورحمه الله',
    'السلام عليكم ورحمه الله وبركاته',
    'وعليكم السلام',
    'وعليكم السلام ورحمه الله',
    'وعليكم السلام ورحمه الله وبركاته',
    'سلام عليكم',
    'سلام',
    'اهلا',
    'اهلا بك',
    'اهلا وسهلا',
    'مرحبا',
    'مرحبا بك',
    'ازيك',
    'ازيكم',
    'عامل ايه',
    'اخبارك',
    'اخبارك ايه',
    'كيف حالك',
    'صباح الخير',
    'مساء الخير',
    'هاي',
    'هلو',
    'hi',
    'hello',
    'hey',
    'good morning',
    'good evening',
    'how are you',
    'whats up',
    'sup',
    'salam',
    'assalamu alaikum',
  };

  static const Set<String> _thanksPhrases = {
    'شكرا',
    'شكرا جزيلا',
    'شكرا لك',
    'متشكر',
    'مشكور',
    'جزاك الله خيرا',
    'جزاك الله خير',
    'الله يبارك فيك',
    'بارك الله فيك',
    'تسلم',
    'تسلم ايدك',
    'يعطيك العافيه',
    'الله يعطيك العافيه',
    'تمام',
    'ماشي',
    'حاضر',
    'اوك',
    'اوكي',
    'ok',
    'okay',
    'thanks',
    'thank you',
    'thx',
    'jazakallah',
    'مع السلامه',
    'في امان الله',
    'باي',
    'bye',
    'goodbye',
  };

  static const Set<String> _identityPhrases = {
    'انت مين',
    'مين انت',
    'من انت',
    'عرفني بنفسك',
    'بتعمل ايه',
    'تقدر تعمل ايه',
    'ماذا تستطيع ان تفعل',
    'ايه مميزاتك',
    'مساعده',
    'ساعدني',
    'help',
    'who are you',
    'what can you do',
    'what are you',
  };

  /// Normalizes Arabic text for consistent matching.
  static String normalizeArabic(String text) {
    return text
        .replaceAll(RegExp(r'[\u064B-\u065F\u0670\u0640]'), '')
        .replaceAll('إ', 'ا')
        .replaceAll('أ', 'ا')
        .replaceAll('آ', 'ا')
        .replaceAll('ة', 'ه')
        .replaceAll('ى', 'ي')
        .toLowerCase()
        .replaceAll(RegExp(r'[^\u0621-\u064A0-9a-zA-Z\s]'), ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  /// Detects whether the user's message is primarily Arabic or English.
  static bool _isArabicInput(String raw, String fallbackLocale) {
    if (RegExp(r'[\u0600-\u06FF]').hasMatch(raw)) return true;
    if (RegExp('[a-zA-Z]').hasMatch(raw)) return false;
    return fallbackLocale.toLowerCase().startsWith('ar');
  }

  /// Strips leading greetings/polite fillers so RAG embeds only the real intent.
  static String _stripLeadingGreeting(String raw) {
    final prefixes = [
      RegExp(
        r'^(السلام عليكم( ورحمة الله( وبركاته)?)?|سلام عليكم|أهلاً|اهلا|مرحباً|مرحبا|لو سمحت|من فضلك|ممكن|يا شيخ|please|can you|could you)\s*[،,!.؟?\-]*\s*',
        caseSensitive: false,
      ),
    ];
    String result = raw.trim();
    for (final rx in prefixes) {
      final stripped = result.replaceFirst(rx, '').trim();
      if (stripped.isNotEmpty) {
        result = stripped;
      }
    }
    return result;
  }

  /// Instance method delegating to [route] for DI-friendly usage.
  HojatyRouteResult classify(String rawMessage, {String localeCode = 'ar'}) {
    return route(rawMessage, localeCode: localeCode);
  }

  /// Main routing entry point. Guarantees 3-way mutually exclusive routing.
  static HojatyRouteResult route(
    String rawMessage, {
    String localeCode = 'ar',
  }) {
    final trimmed = rawMessage.trim();
    final norm = normalizeArabic(trimmed);
    final isArabic = _isArabicInput(trimmed, localeCode);

    // 1. Empty / symbols-only / gibberish / test noise -> NO_OP
    if (_isInvalidOrNoise(norm)) {
      return HojatyRouteResult(
        intent: HojatyIntent.noOp,
        route: HojatyQueryRoute.invalidOrNoise,
        cleanedQuery: trimmed,
        instantReply: isArabic
            ? 'أهلاً بك! لم أفهم طلبك بوضوح. يمكنك سؤالي عن آية أو حديث أو دعاء، أو طلب تنفيذ أمر داخل التطبيق مثل: "مواقيت الصلاة" أو "شغل سورة الكهف".'
            : 'Welcome! I did not understand that clearly. You can ask me an Islamic question (Quran, Hadith, Tafsir, Dua) or request an app action like "prayer times" or "play Surah Al-Kahf".',
      );
    }

    // 2. Pure Chitchat / Greetings / Thanks / Off-topic -> NO_OP
    final chitchatReply = _matchPureChitchatOrOffTopic(norm, isArabic: isArabic);
    if (chitchatReply != null) {
      return HojatyRouteResult(
        intent: HojatyIntent.noOp,
        route: HojatyQueryRoute.chitchat,
        cleanedQuery: trimmed,
        instantReply: chitchatReply,
      );
    }

    final cleanedQuery = _stripLeadingGreeting(trimmed);
    final normClean = normalizeArabic(cleanedQuery);

    // 3. Explicit Live Stream request -> NO_OP (removed feature, prevent RAG/Surah mismatch)
    if (_isRemovedLiveStreamRequest(normClean)) {
      return HojatyRouteResult(
        intent: HojatyIntent.noOp,
        route: HojatyQueryRoute.chitchat,
        cleanedQuery: trimmed,
        instantReply: isArabic
            ? 'عذراً، ميزة البث المباشر لإذاعة مكة والمدينة غير متوفرة حالياً في المساعد. يمكنك تشغيل تلاوة أي سورة من القرآن الكريم (مثل: "شغل سورة الكهف").'
            : 'Live broadcast streams for Makkah and Madinah are currently unavailable in the assistant. You can ask me to play any Quran surah recitation instead (e.g., "Play Surah Al-Kahf").',
      );
    }

    // 4. Knowledge question guard: questions like "ما حكم..." / "تفسير..." / "what is the ruling..."
    // must go to KNOWLEDGE_RAG, NOT be hijacked by app tool triggers.
    final isKnowledgeQuestion = _isKnowledgeQuestion(normClean);

    // 5. ACTION_TOOL: Direct deterministic Tool Command OR AI Tool Calling (0 RAG)
    if (!isKnowledgeQuestion) {
      final directTool = matchDirectToolCommand(normClean);
      if (directTool != null) {
        return HojatyRouteResult(
          intent: HojatyIntent.actionTool,
          route: HojatyQueryRoute.directToolCommand,
          cleanedQuery: cleanedQuery,
          directToolCall: directTool,
        );
      }

      if (_isAdvancedAppCommand(normClean)) {
        return HojatyRouteResult(
          intent: HojatyIntent.actionTool,
          route: HojatyQueryRoute.aiToolCommand,
          cleanedQuery: cleanedQuery,
        );
      }
    }

    // 6. KNOWLEDGE_RAG: Single-Source vs Multi-Source RAG (0 Tools)
    if (_isSingleSourceQuery(normClean)) {
      return HojatyRouteResult(
        intent: HojatyIntent.knowledgeRag,
        route: HojatyQueryRoute.ragSingleSource,
        cleanedQuery: cleanedQuery,
      );
    }

    return HojatyRouteResult(
      intent: HojatyIntent.knowledgeRag,
      route: HojatyQueryRoute.ragMultiSource,
      cleanedQuery: cleanedQuery,
    );
  }

  static bool _isInvalidOrNoise(String norm) {
    if (norm.isEmpty) return true;

    // Pure digits or whitespace-separated numbers
    if (RegExp(r'^[\d\s]+$').hasMatch(norm)) return true;

    // Known test / laughter / keyboard-mash noise
    if (_noiseWords.contains(norm)) return true;

    final compact = norm.replaceAll(' ', '');
    if (compact.length < 2) return true;

    // Repeated single character (e.g. "هههههه", "اااا", "xxxx")
    if (RegExp(r'^(.)\1+$').hasMatch(compact)) {
      return true;
    }

    // Repeated 2-char pattern (e.g. "ababab", "هيهيهي", "121212")
    if (compact.length >= 4 && RegExp(r'^(.{2})\1+$').hasMatch(compact)) {
      return true;
    }

    // Very low unique-character ratio on longer strings (e.g. "asdasdasd", "ضضضضصص")
    if (compact.length >= 6 && compact.split('').toSet().length <= 2) {
      return true;
    }

    final hasArabic = RegExp(r'[\u0621-\u064A]').hasMatch(norm);

    // Random Latin keyboard mash (short non-greeting or vowel-less long consonant string)
    if (!hasArabic) {
      if (compact.length <= 4 &&
          !_greetingPhrases.contains(norm) &&
          !_thanksPhrases.contains(norm)) {
        return true;
      }
      final lettersOnly = compact.replaceAll(RegExp('[^a-z]'), '');
      if (lettersOnly.length >= 5 && !RegExp('[aeiouy]').hasMatch(lettersOnly)) {
        return true;
      }
      // Keyboard row mash check
      const qwertyRows = ['qwertyuiop', 'asdfghjkl', 'zxcvbnm'];
      if (lettersOnly.length >= 4 &&
          qwertyRows.any((row) => row.contains(lettersOnly))) {
        return true;
      }
    } else {
      // Arabic keyboard row mash check (e.g., "ضصثقفغ", "شسيبلاتنم")
      const arabicRows = ['ضصثقفغعهخحجد', 'شسيبلاتنمكط', 'ئءؤرلاىةوزظ'];
      if (compact.length >= 4 &&
          arabicRows.any((row) => row.contains(compact))) {
        return true;
      }
    }

    return false;
  }

  static String? _matchPureChitchatOrOffTopic(
    String norm, {
    required bool isArabic,
  }) {
    if (_greetingPhrases.contains(norm)) {
      return isArabic
          ? 'وعليكم السلام ورحمة الله وبركاته! أهلاً بك في مساعد حجتي، كيف يمكنني مساعدتك اليوم؟'
          : 'Wa alaykum assalam! Welcome to Hojaty Assistant. How can I help you today?';
    }
    if (_thanksPhrases.contains(norm)) {
      return isArabic
          ? 'وجزاك الله خيراً! في خدمتك دائماً إن احتجت أي مساعدة أخرى.'
          : 'You are most welcome! Let me know anytime you need help.';
    }
    if (_identityPhrases.contains(norm)) {
      return isArabic
          ? 'أنا مساعد (حجتي) الذكي. أساعدك في:\n'
              '• البحث الموثق في القرآن والتفسير والأحاديث والأذكار والأدعية.\n'
              '• تنفيذ أوامر التطبيق مباشرة (مواقيت الصلاة، تشغيل القرآن، الأذكار، القبلة، السبحة، والتنبيهات).'
          : 'I am Hojaty AI Assistant. I can help you with:\n'
              '• Verified answers from the Quran, Tafsir, Hadith, Athkar, and Duas.\n'
              '• Direct app actions (Prayer times, Quran playback, Athkar, Qibla, Sebha, and alerts).';
    }

    // Casual off-topic chat (weather, sports, coding, jokes, general smalltalk)
    const offTopicKeywords = [
      'الطقس',
      'درجه الحراره',
      'حاله الجو',
      'اخبار الكوره',
      'مباراه',
      'كوره القدم',
      'نكته',
      'احكيلي نكته',
      'برمجه',
      'اكتب كود',
      'سعر الدولار',
      'weather',
      'forecast',
      'tell me a joke',
      'football score',
      'write code',
      'python',
      'javascript',
    ];
    for (final kw in offTopicKeywords) {
      if (norm.contains(kw)) {
        return isArabic
            ? 'أنا متخصص في الأسئلة الإسلامية (القرآن، الحديث، التفسير، الأذكار) وتنفيذ أوامر تطبيق حجتي فقط. كيف يمكنني مساعدتك في ذلك؟'
            : 'I specialize in Islamic knowledge (Quran, Hadith, Tafsir, Athkar) and Hojaty app actions. How can I assist you with those?';
      }
    }

    return null;
  }

  static bool _isRemovedLiveStreamRequest(String norm) {
    const liveStreamPatterns = [
      'بث مباشر',
      'البث المباشر',
      'بث مكه',
      'بث المدينه',
      'بث الحرم',
      'اذاعه القران',
      'راديو القران',
      'اذاعه مكه',
      'اذاعه المدينه',
      'الحرم المكي مباشر',
      'الحرم النبوي مباشر',
      'makkah live',
      'madinah live',
      'live stream',
      'quran radio',
    ];
    for (final p in liveStreamPatterns) {
      if (norm.contains(p)) return true;
    }
    return false;
  }

  static bool _isKnowledgeQuestion(String norm) {
    const knowledgeStarters = [
      'ما حكم',
      'ما هو حكم',
      'هل يجوز',
      'ما فضل',
      'فضل ',
      'ما معني',
      'معني ',
      'تفسير ',
      'شرح ',
      'قصه ',
      'ما هي شروط',
      'ما هي اركان',
      'اذكر حديث',
      'اذكر ايه',
      'ما صحه حديث',
      'كيف اصلي',
      'كيف اتوضا',
      'ما هو دعاء',
      'ما دعاء',
      'دعاء بعد الاذان',
      'دعاء الاذان',
      'what is the ruling',
      'is it permissible',
      'tafsir of',
      'meaning of',
      'hadith about',
      'dua for',
    ];
    for (final starter in knowledgeStarters) {
      if (norm.startsWith(starter) || norm.contains(starter)) {
        return true;
      }
    }
    return false;
  }

  /// Matches clear, deterministic in-app commands locally without calling RAG or Gemini.
  static AiToolCallModel? matchDirectToolCommand(String normQuery) {
    // 1. Surah Audio Playback (Live stream removed)
    final hasAudioVerb = normQuery.contains('شغل') ||
        normQuery.contains('تشغيل') ||
        normQuery.contains('استمع') ||
        normQuery.contains('اسمع') ||
        normQuery.contains('سمعني') ||
        normQuery.contains('play ');

    if (hasAudioVerb) {
      if (normQuery.contains('انا اصلي') ||
          normQuery.contains('الوضع الليلي') ||
          normQuery.contains('تنبيه') ||
          normQuery.contains('اشعار')) {
        return null;
      }

      int? surahNumber;
      String? surahName;
      for (final s in QuranConstants.surahMap.values) {
        final normSurah = normalizeArabic(s.name);
        final normEn = s.englishName.toLowerCase();
        if ((normSurah.length >= 2 && normQuery.contains(normSurah)) ||
            (normEn.length >= 3 && normQuery.contains(normEn))) {
          surahNumber = s.number;
          surahName = s.name;
          break;
        }
      }

      if (surahNumber != null) {
        String reciter = 'عبد الباسط عبد الصمد';
        if (normQuery.contains('الحصري') || normQuery.contains('husary')) {
          reciter = 'محمود خليل الحصري';
        } else if (normQuery.contains('المنشاوي') || normQuery.contains('minshawi')) {
          reciter = 'محمد صديق المنشاوي';
        } else if (normQuery.contains('العفاسي') ||
            normQuery.contains('مشاري') ||
            normQuery.contains('afasy')) {
          reciter = 'مشاري راشد العفاسي';
        } else if (normQuery.contains('بصوت') || normQuery.contains('للقارئ')) {
          return null;
        }

        return AiToolCallModel(
          id: 'direct_audio',
          name: HojatyToolRegistry.toolPlayQuranAudio,
          arguments: {
            'surahNumber': surahNumber,
            'surahName': surahName,
            'reciterName': reciter,
          },
        );
      }
    }

    // 2. Prayer Times (direct for today/tomorrow without custom city)
    final isPrayerTimeQuery = normQuery.contains('مواقيت') ||
        normQuery.contains('اوقات الصلاه') ||
        normQuery.contains('ميعاد الصلاه') ||
        normQuery.contains('موعد الصلاه') ||
        normQuery.contains('وقت الصلاه') ||
        normQuery.contains('الصلاه الجايه') ||
        normQuery.contains('الصلاه القادمه') ||
        normQuery.contains('كم باقي علي صلاه') ||
        normQuery.contains('متي اذان') ||
        normQuery.contains('امتي اذان') ||
        normQuery.contains('موعد اذان') ||
        normQuery.contains('ميعاد اذان') ||
        normQuery.contains('prayer time') ||
        normQuery.contains('next prayer');

    if (isPrayerTimeQuery &&
        !normQuery.contains('تنبيه') &&
        !normQuery.contains('اشعار') &&
        !normQuery.contains('ذكرني')) {
      if (RegExp(r'\bفي\s+[\u0621-\u064A]{3,}').hasMatch(normQuery) ||
          RegExp(r'\bin\s+[a-z]{3,}').hasMatch(normQuery)) {
        return null;
      }

      int offset = 0;
      if (normQuery.contains('غدا') ||
          normQuery.contains('بكره') ||
          normQuery.contains('tomorrow')) {
        offset = 1;
      } else if (normQuery.contains('امس') ||
          normQuery.contains('امبارح') ||
          normQuery.contains('yesterday')) {
        offset = -1;
      }

      return AiToolCallModel(
        id: 'direct_prayers',
        name: HojatyToolRegistry.toolGetPrayerTimes,
        arguments: {'dateOffsetDays': offset},
      );
    }

    // 3. Open Athkar Category
    if (normQuery.contains('اذكار الصباح') || normQuery.contains('morning athkar')) {
      return const AiToolCallModel(
        id: 'direct_athkar_morning',
        name: HojatyToolRegistry.toolOpenAthkarCategory,
        arguments: {'categoryType': 'morning', 'categoryTitle': 'أذكار الصباح'},
      );
    }
    if (normQuery.contains('اذكار المساء') || normQuery.contains('evening athkar')) {
      return const AiToolCallModel(
        id: 'direct_athkar_evening',
        name: HojatyToolRegistry.toolOpenAthkarCategory,
        arguments: {'categoryType': 'evening', 'categoryTitle': 'أذكار المساء'},
      );
    }
    if (normQuery.contains('اذكار النوم') || normQuery.contains('sleep athkar')) {
      return const AiToolCallModel(
        id: 'direct_athkar_sleep',
        name: HojatyToolRegistry.toolOpenAthkarCategory,
        arguments: {'categoryType': 'sleep', 'categoryTitle': 'أذكار النوم'},
      );
    }
    if (normQuery.contains('اذكار بعد الصلاه') ||
        normQuery.contains('اذكار الصلاه') ||
        normQuery.contains('after prayer athkar')) {
      return const AiToolCallModel(
        id: 'direct_athkar_after_prayer',
        name: HojatyToolRegistry.toolOpenAthkarCategory,
        arguments: {
          'categoryType': 'afterPrayer',
          'categoryTitle': 'أذكار بعد الصلاة',
        },
      );
    }

    // 4. Sebha Counter
    if (normQuery.contains('سبحه') ||
        normQuery.contains('المسبحه') ||
        normQuery.contains('تصفير التسبيح') ||
        normQuery.contains('sebha') ||
        normQuery.contains('tasbeeh')) {
      String action = 'get';
      if (normQuery.contains('صفر') ||
          normQuery.contains('تصفير') ||
          normQuery.contains('مسح') ||
          normQuery.contains('امسح') ||
          normQuery.contains('اعاده') ||
          normQuery.contains('reset')) {
        action = 'reset';
      } else if (normQuery.contains('افتح') || normQuery.contains('open')) {
        action = 'open_screen';
      }
      return AiToolCallModel(
        id: 'direct_sebha',
        name: HojatyToolRegistry.toolControlSebhaCounter,
        arguments: {'action': action},
      );
    }

    // 5. Qibla Compass
    if ((normQuery.contains('قبله') || normQuery.contains('qibla')) &&
        (normQuery.contains('افتح') ||
            normQuery.contains('اتجاه') ||
            normQuery.contains('بوصله') ||
            normQuery.contains('فين') ||
            normQuery.contains('اين') ||
            normQuery.contains('open') ||
            normQuery.contains('direction') ||
            normQuery == 'القبله' ||
            normQuery == 'قبله' ||
            normQuery == 'qibla')) {
      return const AiToolCallModel(
        id: 'direct_qibla',
        name: HojatyToolRegistry.toolOpenQiblaCompass,
        arguments: {'openScreen': true},
      );
    }

    // 6. Open Quran Reader (requires explicit open/read action verb)
    final hasOpenOrReadVerb = normQuery.contains('افتح') ||
        normQuery.contains('اقرا') ||
        normQuery.contains('وديني') ||
        normQuery.contains('روح ل') ||
        normQuery.contains('open ') ||
        normQuery.contains('read ');

    if (hasOpenOrReadVerb &&
        (normQuery.contains('المصحف') ||
            normQuery.contains('صفحه') ||
            normQuery.contains('سوره') ||
            normQuery.contains('quran') ||
            normQuery.contains('surah') ||
            normQuery.contains('page'))) {
      int? targetPage;
      int? surahNumber;
      for (final s in QuranConstants.surahMap.values) {
        final normSurah = normalizeArabic(s.name);
        final normEn = s.englishName.toLowerCase();
        if ((normSurah.length >= 2 && normQuery.contains(normSurah)) ||
            (normEn.length >= 3 && normQuery.contains(normEn))) {
          targetPage = s.pageNumber;
          surahNumber = s.number;
          break;
        }
      }

      if (targetPage == null) {
        final match = RegExp(r'\d+').firstMatch(normQuery);
        if (match != null) {
          final parsed = int.tryParse(match.group(0)!);
          if (parsed != null && parsed >= 1 && parsed <= 604) {
            targetPage = parsed;
          }
        }
      }

      return AiToolCallModel(
        id: 'direct_quran',
        name: HojatyToolRegistry.toolOpenQuranReader,
        arguments: {
          'pageNumber': targetPage ?? 1,
          'surahNumber': ?surahNumber,
        },
      );
    }

    return null;
  }

  /// Detects complex app commands that should call Gemini with Tool Calling ONLY (no RAG).
  static bool _isAdvancedAppCommand(String norm) {
    const commandKeywords = [
      // Prayer alerts & notifications
      'تنبيه',
      'اشعار',
      'ذكرني قبل',
      'تذكير قبل',
      'فعل الاذان',
      'اقفل الاذان',
      'ايقاف الاذان',
      'صوت الاذان',
      'غير الاذان',
      'prayer alert',
      'adhan reminder',
      'enable adhan',
      'disable adhan',
      // App preferences / theme / font / Ana Osaly mode
      'الوضع الليلي',
      'الوضع الداكن',
      'الوضع النهاري',
      'الوضع الفاتح',
      'اموليد',
      'الثيم',
      'حجم الخط',
      'كبر الخط',
      'صغر الخط',
      'انا اصلي',
      'الرد التلقائي',
      'dark mode',
      'light mode',
      'amoled',
      'font size',
      // Bookmarks
      'احفظ علامه',
      'حفظ علامه',
      'علامه مرجعيه',
      'اخر صفحه قراتها',
      'فين وقفت في المصحف',
      'save bookmark',
      'last bookmark',
      // Hadith book reader navigation
      'افتح صحيح البخاري',
      'افتح صحيح مسلم',
      'افتح البخاري',
      'افتح مسلم',
      'افتح الاربعين النوويه',
      'افتح كتاب الحديث',
      'open bukhari',
      'open muslim',
      // Audio / prayer with extra params not caught by direct matcher
      'شغل سوره',
      'شغل قران',
      'تشغيل سوره',
      'تشغيل قران',
      'play surah',
      'play quran',
      'مواقيت الصلاه في',
      'اوقات الصلاه في',
      'اذان الفجر في',
      'اذان الظهر في',
      'اذان العصر في',
      'اذان المغرب في',
      'اذان العشاء في',
      'prayer times in',
    ];

    for (final kw in commandKeywords) {
      if (norm.contains(kw)) return true;
    }
    return false;
  }

  /// Determines when a single, focused RAG source is better than multiple sources.
  static bool _isSingleSourceQuery(String norm) {
    const multiSourceIndicators = [
      'اشعر ب',
      'حاسس ب',
      'مكتئب',
      'حزين',
      'قلقان',
      'خايف',
      'مهموم',
      'ضيق',
      'مشكله',
      'نصيحه',
      'نصائح',
      'كيف اتقرب',
      'كيف احافظ',
      'كيف اتعامل',
      'قصه ',
      'احكام ',
      'شروط ',
      'اركان ',
      'الفرق بين',
      'اذكر لي احاديث',
      'اذكر لي ايات',
      'ادله علي',
      'فضل بر الوالدين',
      'محتاج تشجيع',
      'تعبان نفسيا',
    ];
    for (final ind in multiSourceIndicators) {
      if (norm.contains(ind)) return false;
    }

    const singleSourceIndicators = [
      'ايه الكرسي',
      'سيد الاستغفار',
      'دعاء ',
      'تفسير ايه',
      'تفسير قوله',
      'تفسير سوره',
      'معني اسم الله',
      'معني كلمه',
      'ما معني',
      'نص حديث',
      'حديث ',
      'اذكر حديث',
      'اذكر ايه',
      'اذكر دعاء',
      'ايه عن',
      'كم عدد',
      'من هو النبي',
      'ما هي السوره',
    ];
    for (final ind in singleSourceIndicators) {
      if (norm.contains(ind)) return true;
    }

    final words = norm.split(' ').where((w) => w.isNotEmpty).toList();
    return words.length <= 5;
  }
}

class HojatyToolRegistry {
  /// Name constants for tools
  static const String toolPlayQuranAudio = 'play_quran_audio';
  static const String toolGetPrayerTimes = 'get_prayer_times';
  static const String toolOpenQuranReader = 'open_quran_reader';
  static const String toolConfigurePrayerAlerts = 'configure_prayer_alerts';
  static const String toolOpenAthkarCategory = 'open_athkar_category';
  static const String toolControlSebhaCounter = 'control_sebha_counter';
  static const String toolManageQuranBookmark = 'manage_quran_bookmark';
  static const String toolOpenHadithReader = 'open_hadith_reader';
  static const String toolOpenQiblaCompass = 'open_qibla_compass';
  static const String toolUpdateAppPreferences = 'update_app_preferences';

  /// Standard Gemini Tools list containing all function declarations
  static List<Map<String, dynamic>> getGeminiToolsDeclaration() {
    return [
      {
        'functionDeclarations': [
          {
            'name': toolPlayQuranAudio,
            'description':
                'Plays a specific Quran surah recitation (surahNumber 1-114) or live Quran radio stream in the background',
            'parameters': {
              'type': 'OBJECT',
              'properties': {
                'surahNumber': {
                  'type': 'INTEGER',
                  'description': 'Surah number from 1 (Al-Fatiha) to 114 (An-Nas)',
                },
                'surahName': {
                  'type': 'STRING',
                  'description': 'Name of the surah in Arabic (e.g. البقرة، الكهف)',
                },
                'reciterName': {
                  'type': 'STRING',
                  'description': 'Name of the reciter (e.g. عبد الباسط، الحصري، المنشاوي، مشاري العفاسي)',
                },
                'isLiveStream': {
                  'type': 'BOOLEAN',
                  'description': 'Set true if user asked for live radio stream',
                },
                'streamType': {
                  'type': 'STRING',
                  'description': 'cairo, makkah, or madinah for live streams',
                },
              },
            },
          },
          {
            'name': toolGetPrayerTimes,
            'description':
                'Calculates precise Islamic prayer times (Fajr, Sunrise, Dhuhr, Asr, Maghrib, Isha) and remaining time until next prayer',
            'parameters': {
              'type': 'OBJECT',
              'properties': {
                'cityName': {
                  'type': 'STRING',
                  'description': 'Optional city name (e.g. القاهرة، الإسكندرية)',
                },
                'dateOffsetDays': {
                  'type': 'INTEGER',
                  'description': '0 for today, 1 for tomorrow, -1 for yesterday',
                },
              },
            },
          },
          {
            'name': toolOpenQuranReader,
            'description':
                'Navigates to the Quran reader at a specific page (1 to 604) or highlights a specific verse/ayah in a surah',
            'parameters': {
              'type': 'OBJECT',
              'properties': {
                'pageNumber': {
                  'type': 'INTEGER',
                  'description': 'Page number from 1 to 604',
                },
                'surahNumber': {
                  'type': 'INTEGER',
                  'description': 'Surah number 1 to 114',
                },
                'verseIndex': {
                  'type': 'INTEGER',
                  'description': 'Verse/Ayah number within the surah',
                },
              },
            },
          },
          {
            'name': toolConfigurePrayerAlerts,
            'description':
                'Configures adhan notification alerts, pre-adhan reminder minutes, or adhan sound voice',
            'parameters': {
              'type': 'OBJECT',
              'properties': {
                'prayerName': {
                  'type': 'STRING',
                  'description': 'fajr, dhuhr, asr, maghrib, isha, or all',
                },
                'enabled': {
                  'type': 'BOOLEAN',
                  'description': 'Whether alerts for this prayer are enabled',
                },
                'preReminderMinutes': {
                  'type': 'INTEGER',
                  'description': 'Pre-adhan reminder minutes (e.g. 5, 10, 15)',
                },
                'soundId': {
                  'type': 'STRING',
                  'description': 'Adhan sound voice: makkah, madinah, cairo, aqsa',
                },
              },
              'required': ['prayerName'],
            },
          },
          {
            'name': toolOpenAthkarCategory,
            'description':
                'Opens a specific Athkar / Dhikr category (e.g. morning, evening, sleep, after-prayer, istikhara) in the interactive Athkar counter screen',
            'parameters': {
              'type': 'OBJECT',
              'properties': {
                'categoryType': {
                  'type': 'STRING',
                  'description': 'morning, evening, sleep, afterPrayer, or istikhara',
                },
                'categoryTitle': {
                  'type': 'STRING',
                  'description': 'Title in Arabic (e.g. أذكار الصباح، أذكار المساء، أذكار النوم)',
                },
              },
              'required': ['categoryType'],
            },
          },
          {
            'name': toolControlSebhaCounter,
            'description':
                'Controls the electronic digital Sebha (Tasbeeh counter): get current count, reset to 0, increment, set count, or open Sebha screen',
            'parameters': {
              'type': 'OBJECT',
              'properties': {
                'action': {
                  'type': 'STRING',
                  'description': 'get, reset, set_count, or open_screen',
                },
                'count': {
                  'type': 'INTEGER',
                  'description': 'Target or newly recorded count',
                },
                'dhikrPhrase': {
                  'type': 'STRING',
                  'description': 'Optional phrase (e.g. سبحان الله، أستغفر الله)',
                },
              },
              'required': ['action'],
            },
          },
          {
            'name': toolManageQuranBookmark,
            'description':
                'Saves or retrieves a reading checkpoint/bookmark in the Quran',
            'parameters': {
              'type': 'OBJECT',
              'properties': {
                'action': {
                  'type': 'STRING',
                  'description': 'save or get_latest',
                },
                'pageNumber': {
                  'type': 'INTEGER',
                  'description': 'Page number 1 to 604',
                },
                'verseIndex': {
                  'type': 'INTEGER',
                  'description': 'Verse number',
                },
                'surahName': {
                  'type': 'STRING',
                  'description': 'Surah name in Arabic',
                },
              },
              'required': ['action'],
            },
          },
          {
            'name': toolOpenHadithReader,
            'description':
                'Opens a specific Hadith or chapter in the Islamic books library (e.g. Sahih al-Bukhari, Sahih Muslim)',
            'parameters': {
              'type': 'OBJECT',
              'properties': {
                'bookId': {
                  'type': 'STRING',
                  'description': 'bukhari, muslim, nawawi40, etc.',
                },
                'chapterId': {
                  'type': 'INTEGER',
                  'description': 'Chapter ID if known',
                },
                'hadithId': {
                  'type': 'INTEGER',
                  'description': 'Hadith number if known',
                },
                'queryText': {
                  'type': 'STRING',
                  'description': 'Search text for hadith',
                },
              },
              'required': ['bookId'],
            },
          },
          {
            'name': toolOpenQiblaCompass,
            'description':
                'Calculates Kaaba azimuth direction, angle, and distance from user location, and opens Qibla compass',
            'parameters': {
              'type': 'OBJECT',
              'properties': {
                'openScreen': {
                  'type': 'BOOLEAN',
                  'description': 'True to navigate to the compass screen',
                },
              },
            },
          },
          {
            'name': toolUpdateAppPreferences,
            'description':
                'Updates app appearance and accessibility settings: dark/light theme, font size, or "Ana Osaly" quiet/auto-reply mode',
            'parameters': {
              'type': 'OBJECT',
              'properties': {
                'themeMode': {
                  'type': 'STRING',
                  'description': 'light, dark, or amoled',
                },
                'fontSize': {
                  'type': 'NUMBER',
                  'description': 'Font size (e.g. 18, 22, 26, 30)',
                },
                'enableAnaOsalyQuiet': {
                  'type': 'BOOLEAN',
                  'description': 'Toggle Ana Osaly quiet mode',
                },
              },
            },
          },
        ],
      }
    ];
  }
}


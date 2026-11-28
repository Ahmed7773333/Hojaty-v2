
<role>
You are a Principal Flutter Architect and Mobile Audio Systems Engineer specializing in offline-first, production-grade Islamic applications (RTL Arabic primary, iOS & Android). You write clean, defensive, zero-placeholder Dart/Flutter code with strict attention to audio lifecycle edge cases, performance (60/120 FPS), and App Store / Google Play compliance.
</role>

<objective>
Design and implement a complete, production-ready **Quran Memorization ("Hifz" / "حِفظي")** feature inside the existing **Hojaty** Flutter application.
This feature will live as a dedicated tab in the main Bottom Navigation Bar and provide:
1. Structured memorization tracks (e.g., Surah Al-Baqarah 40-day / 10-milestone journey, Al-Mulk, Al-Kahf, Juz Amma) + custom plans + frictionless "Quick Loop" mode.
2. A rock-solid, background-capable Audio Repetition Engine supporting ayah repetition, range repetition, **Cumulative Chaining (الربط التراكمي)**, and **Pause-to-Repeat (سكتة الترديد)** with offline caching and automatic CDN fallback.
3. A distraction-free Memorization Studio supporting **Focus Card Mode**, **Interactive Mushaf Overlay Mode**, and **Self-Testing (Hide & Reveal + First-Word/Audio Hint)**.
4. Offline-first **Spaced Repetition Review (Leitner 5-Box System)** and daily streak tracking stored locally via Drift/SQLite.
</objective>

<phase_0_codebase_discovery>
BEFORE writing any code, inspect the existing repository to ensure seamless integration without duplicating assets or breaking production patterns:
1. Inspect `pubspec.yaml` for existing packages (e.g., `drift`, `flutter_bloc`, `just_audio`, `audio_service`, `audio_session`, `wakelock_plus`, `dio`/`http`, `path_provider`, `get_it`/`injectable`, `freezed`/`equatable`). Reuse existing packages and only propose adding strictly missing ones.
2. Inspect how Quran text, Surah metadata, and Mushaf pages / Ayah bounding boxes are currently stored and rendered in Hojaty. **Reuse existing Quran text/Mushaf data sources** — do NOT duplicate the Quran text dataset.
3. Inspect the existing Drift database setup, DI container, Theme/Design System (including Arabic typography, dark/light themes, and any glassmorphism/blur styles), Localization/RTL setup, and Bottom Navigation Bar router.
4. Output a brief **Integration Plan** confirming exact file paths and any reused services before beginning Phase 1 implementation.
</phase_0_codebase_discovery>

<architecture>
Follow strict **Clean Architecture** inside `lib/features/hifz/` so the audio engine remains completely decoupled from Flutter UI widgets:

```text
lib/features/hifz/
├── data/
│   ├── datasources/
│   │   ├── hifz_local_dao.dart          # Drift DAOs (Plans, Mastery, Activity Logs, Cache Index)
│   │   ├── curated_tracks_loader.dart   # Loads assets/data/hifz_tracks.json
│   │   └── audio_cache_manager.dart     # Atomic download, sliding-window prefetch, LRU eviction, fallback
│   ├── models/                          # ReciterConfig, CuratedTrackModel
│   └── repositories/
│       └── hifz_repository_impl.dart
├── domain/
│   ├── entities/                        # HifzPlan, HifzStep, AyahMastery, Reciter, HifzSessionConfig
│   ├── repositories/
│   │   └── hifz_repository.dart
│   ├── utils/
│   │   └── global_ayah_mapper.dart      # O(1) bidirectional converter: globalAyahId (1..6236) <-> (surah, ayah)
│   └── usecases/
│       ├── generate_playback_queue.dart # Pure Dart deterministic repetition & chaining engine
│       └── calculate_spaced_review.dart # Leitner 5-box spaced repetition scheduler
├── engine/
│   ├── hifz_audio_handler.dart          # BaseAudioHandler (audio_service + just_audio + audio_session)
│   └── hifz_session_orchestrator.dart   # Step runner, Pause-to-Repeat silence driver, Basmalah handler
└── presentation/
    ├── cubits/
    │   ├── hifz_hub_cubit.dart          # Persistent state: active plan, today's wird, due reviews, streaks
    │   └── hifz_session_cubit.dart      # Live session state: playback, repeat countdown, testing masks
    ├── screens/
    │   ├── hifz_hub_screen.dart         # Main Bottom Nav tab
    │   ├── hifz_studio_screen.dart      # Full-screen distraction-free memorization & testing studio
    │   ├── track_setup_sheet.dart       # Curated track preview / Custom plan / Quick Loop selector
    │   └── audio_storage_sheet.dart     # Offline surah downloader & cache size manager
    └── widgets/
        ├── focus_card_view.dart
        ├── mushaf_overlay_view.dart
        ├── smart_loop_dock.dart
        ├── repeat_countdown_pill.dart
        └── hifz_mini_player.dart


</architecture>

<data_layer_and_schema>

1. Global Ayah Indexing (Critical Best Practice)

Internally store and compute all plan ranges and mastery records using global_ayah_id (1 to 6236) rather than (surah, ayah) tuples.

⚬ Reason: Multi-surah tracks (like Juz Amma, which spans 37 surahs) become trivial arithmetic (currentGlobalAyah + dailyTarget) with zero boundary bugs.
⚬ Implement GlobalAyahMapper with a static const array of 114 surah cumulative offsets for O(1) conversion between globalAyahId and (surahId, ayahNumber).

2. Drift / SQLite Tables (100% Offline-First)

Add these 4 tables (properly indexed and migrated in the existing Drift DB):

1. hifz_plans
  ⚬ id: IntColumn (PK, autoIncrement)
  ⚬ trackKey: TextColumn (nullable; e.g., 'baqarah_40_days', null for custom)
  ⚬ title: TextColumn
  ⚬ surahId: IntColumn (1..114, or 0 for multi-surah tracks)
  ⚬ startGlobalAyah: IntColumn
  ⚬ endGlobalAyah: IntColumn
  ⚬ currentGlobalAyah: IntColumn
  ⚬ dailyTargetAyahs: IntColumn
  ⚬ isActive: BoolColumn (default false)
  ⚬ createdAt: DateTimeColumn
2. ayah_mastery (Leitner 5-Box Spaced Repetition)
  ⚬ Intervals: Box 1 -> +1 day | Box 2 -> +3 days | Box 3 -> +7 days | Box 4 -> +14 days | Box 5 -> +30 days.
  ⚬ On successful recall: level = min(5, level + 1). On lapse/forgotten: level = max(1, level - 1), lapseCount++.
  ⚬ globalAyahId: IntColumn (PK)
  ⚬ masteryLevel: IntColumn (1..5)
  ⚬ lastReviewedAt: DateTimeColumn
  ⚬ nextReviewAt: DateTimeColumn (INDEXED)
  ⚬ lapseCount: IntColumn (default 0)
3. hifz_activity_logs (Streak & Analytics)
  ⚬ id: IntColumn (PK, autoIncrement)
  ⚬ planId: IntColumn (nullable)
  ⚬ dateYmd: TextColumn (INDEXED, format 'YYYY-MM-DD' for fast streak queries)
  ⚬ ayahsMemorized: IntColumn (default 0)
  ⚬ ayahsReviewed: IntColumn (default 0)
  ⚬ listeningSeconds: IntColumn (default 0)
4. cached_audio_entries (LRU Cache & Storage Manager)
  ⚬ cacheKey: TextColumn (PK, format '{reciterId}_{sss}{aaa}')
  ⚬ reciterId: TextColumn (INDEXED)
  ⚬ surahId: IntColumn (INDEXED)
  ⚬ fileSizeBytes: IntColumn
  ⚬ isPinned: BoolColumn (default false; true when user manually downloads a full surah)
  ⚬ lastAccessedAt: DateTimeColumn (INDEXED)

3. Curated Tracks Asset (assets/data/hifz_tracks.json)

Create a JSON asset defining ready-made tracks so new tracks can be added without code changes. Include at minimum:

⚬ Surah Al-Baqarah (40 Days — 10 Milestones): 4 days new memorization + 1 milestone review day cadence.
⚬ Surah Al-Mulk (7 Days): ~4-5 ayahs/day.
⚬ Surah Al-Kahf (15 Days): ~7 ayahs/day.
⚬ Surah Yasin (12 Days): ~7 ayahs/day.
⚬ Juz Amma (30 Days): Multi-surah track from An-Naba to An-Nas.

Example JSON schema:

{
  "tracks": [
    {
      "track_key": "baqarah_40_days",
      "title_ar": "رحلة حفظ سورة البقرة",
      "subtitle_ar": "40 يوم • 10 محطات تدريجية مع أيام مراجعة",
      "surah_id": 2,
      "start_global_ayah": 8,
      "end_global_ayah": 293,
      "daily_target_ayahs": 7,
      "review_every_n_days": 4,
      "estimated_days": 40,
      "difficulty": "advanced"
    }
  ]
}


</data_layer_and_schema>

<audio_sources_and_caching>

1. Reciter Registry & Dual-Source Fallback

Define a ReciterRegistry including at least these essential memorization reciters:

⚬ Mahmoud Khalil Al-Husary (Muallim) — id: 'husary_muallim', EveryAyah: 'Husary_Muallim_128kbps', Fallback: 'ar.husarymujawwad'
⚬ Mahmoud Khalil Al-Husary (Murattal) — id: 'husary_64', EveryAyah: 'Husary_64kbps', Fallback: 'ar.husary'
⚬ Mohamed Siddiq Al-Minshawi (Murattal) — id: 'minshawi_128', EveryAyah: 'Minshawy_Murattal_128kbps', Fallback: 'ar.minshawi'
⚬ Mishary Rashid Alafasy — id: 'alafasy_128', EveryAyah: 'Alafasy_128kbps', Fallback: 'ar.alafasy'
⚬ Allow user preference for audio quality (64kbps data-saver vs 128kbps high quality) where supported.

URL Resolution Pipeline:

1. Primary (EveryAyah): https://everyayah.com/data/{everyAyahFolder}/{SSS}{AAA}.mp3
  ⚬ Example (Al-Baqarah 255, Husary): https://everyayah.com/data/Husary_128kbps/002255.mp3
2. Automatic Fallback (Islamic Network CDN): https://cdn.islamic.network/quran/audio/{bitrate}/{islamicNetEdition}/{globalAyahId}.mp3
  ⚬ Example (Al-Baqarah 255 = global 262, Alafasy): https://cdn.islamic.network/quran/audio/128/ar.alafasy/262.mp3
  ⚬ Trigger fallback automatically if Primary times out (> 5 seconds) or returns HTTP status != 200.

2. Local Storage & Atomic Downloads (Zero Corruption)

⚬ Base directory: {ApplicationSupportDirectory}/hifz_audio/{reciterId}/{SSS}{AAA}.mp3
⚬ iOS App Store Compliance: Ensure the hifz_audio directory is excluded from iCloud Backup (e.g., via platform channel setting NSURLIsExcludedFromBackupKey = true or storing non-pinned cache in getApplicationCacheDirectory() and pinned downloads with backup exclusion).
⚬ Atomic Download Flow:
  1. Download to {path}.tmp.
  2. Verify HTTP 200 AND file.lengthSync() > 2048 bytes (reject HTML error pages).
  3. Atomically renameSync from .tmp to .mp3.
  4. Upsert into cached_audio_entries.
⚬ Sliding-Window Pre-fetching:
  ⚬ When a session opens for a range (e.g., Ayah 17–22), prioritize downloading Ayah 17 immediately so playback starts in < 500ms.
  ⚬ Concurrently pre-fetch the next 3 ayahs (maxConcurrentDownloads = 3).
⚬ Auto LRU Eviction:
  ⚬ If total unpinned cache exceeds 150 MB, delete oldest isPinned == false files by lastAccessedAt until under 120 MB.

3. Basmalah Handling

⚬ When starting a session on Ayah 1 of any surah except Al-Fatihah (1) and At-Tawbah (9), play the reciter's Basmalah (001001.mp3) once as an introductory step before Ayah 1. Never repeat Basmalah during ayah repetition loops.
  </audio_sources_and_caching>

<playback_and_repetition_engine>

1. Deterministic Queue Generator (GeneratePlaybackQueue)

Pure Dart UseCase producing a flat List<HifzStep>. Never embed loop counters inside audio player callbacks.

enum StepType { basmalah, singleRepeat, chainLink, fullRangeReview }

class HifzStep {
  final int globalAyahId;
  final int surah;
  final int ayah;
  final int repeatIndex;      // 1-based current repeat
  final int totalRepeats;     // -1 for infinity mode
  final int rangeLoopIndex;   // 1-based current range pass
  final StepType stepType;
}


Concrete Queue Example (Range: Ayah 1..3, ayahRepeat = 3, cumulativeChaining = true, rangeRepeat = 1):

1. [1 (1/3), 1 (2/3), 1 (3/3)] (singleRepeat)
2. [2 (1/3), 2 (2/3), 2 (3/3)] (singleRepeat)
3. [1, 2] (chainLink)
4. [3 (1/3), 3 (2/3), 3 (3/3)] (singleRepeat)
5. [1, 2, 3] (chainLink)

⚬ Live Config Mutation: If the user changes ayahRepeat, cumulativeChaining, or rangeRepeat mid-session, regenerate List<HifzStep> and snap currentStepIndex to the first matching step of the currently playing globalAyahId (do NOT restart the wird from Ayah 1).
⚬ Infinity Mode (ayahRepeat == -1): Loop the current ayah indefinitely until the user manually skips or toggles off.

2. Orchestrator & Background Audio Handler (DO NOT use ConcatenatingAudioSource)

Do NOT use just_audio's ConcatenatingAudioSource for this engine (it breaks cleanly injecting dynamic silence pauses and live config changes). Instead, build:

⚬ HifzAudioHandler extends BaseAudioHandler wrapping a single AudioPlayer (just_audio).
⚬ HifzSessionOrchestrator driving step-by-step execution:
  1. Fetch local file via AudioCacheManager.getOrDownload(reciter, surah, ayah).
  2. Emit state update BEFORE calling player.play() so UI highlights stay synced.
  3. Set AudioSource.file(localPath), apply playbackSpeed (0.75x, 1.0x, 1.25x), and play.
  4. On ProcessingState.completed:
    ⚬ If pauseToRepeat == true (and stepType != basmalah), enter pausingForRepeat phase.
    ⚬ Otherwise advance to currentStepIndex + 1.

3. Critical Production Audio Edge Cases (Mandatory Implementations)

1. iOS Background Suspension Prevention during Pause-to-Repeat:
  ⚬ CRITICAL: Never rely solely on a Dart Timer while the AudioPlayer is stopped/completed, or iOS will suspend the app in the background/lock screen!
  ⚬ Required Solution: Bundle a tiny silent audio asset (assets/audio/silence_30s.mp3, ~20KB). During pausingForRepeat, play a ClippingAudioSource of that silent file clipped to the exact computed pause duration (and optionally play a subtle soft chime before/after). When the clipped silent source completes, advance to the next step. This keeps the native iOS/Android Audio Session continuously active while locked.
2. Ayah Al-Dayn (Long Ayah) Pause Cap:
  ⚬ Dynamic pause duration formula: Duration(milliseconds: (ayahDuration.inMilliseconds * 1.15).round()).clamp(min: 3s, max: 20s).
  ⚬ Also support a user toggle for Fixed Pause Duration (e.g., 5s / 8s) and a prominent "تخطي السكتة / التالي" (Skip Pause) button.
3. Audio Session & Interruptions (audio_session):
  ⚬ Configure AudioSessionConfiguration.speech().
  ⚬ Pause gracefully on phone calls / audio focus loss and resume when appropriate.
  ⚬ Listen to becomingNoisyEventStream (headphones unplugged / Bluetooth disconnected) and immediately pause playback.
4. Lock Screen, Notification & Dynamic Island (audio_service):
  ⚬ Update mediaItem on every step:
    ⚬ title: 'سورة {surahName} — آية {ayah} (تكرار {repeatIndex}/{totalRepeats})'
    ⚬ artist: '{reciterNameAr} • حجتي'
  ⚬ Wire skipToNext / skipToPrevious media controls to navigate ayahs.
    </playback_and_repetition_engine>

<state_management>
Split state cleanly into two Cubits (BLoC/Cubit) to maintain 60/120 FPS and prevent UI jank:

1. HifzHubCubit (Persistent Feature State)

⚬ Streams/queries from Drift: activePlan, todayWirdRange, dueReviews (count + list + estimated minutes), streakDays, curatedTracks, totalCachedBytes.
⚬ Actions: startCuratedTrack, createCustomPlan, completeTodayWird, recordReviewResult(globalAyahId, bool recalled).

2. HifzSessionCubit (Live Studio & Mini-Player State)

⚬ SessionPhase: preparingAudio, playing, pausingForRepeat, pausedByUser, testingMode, completed, offlineBlocked, error.
⚬ ViewMode: focusCard, mushafOverlay.
⚬ State fields:
  ⚬ phase, viewMode, queue, currentStepIndex
  ⚬ reciter, ayahRepeatCount (1, 3, 5, 7, 10, -1), rangeRepeatCount, cumulativeChaining, pauseToRepeat, pauseMode (dynamic vs fixed), playbackSpeed (0.75, 1.0, 1.25)
  ⚬ revealedAyahs (Set<int>), hintedAyahs (Set<int>), masteredAyahs (Set<int>)
  ⚬ ayahCacheMap (Map<int, AudioCacheStatus>)
⚬ Performance Guardrail: NEVER emit 100ms playback position or repeat-countdown ticks into the root HifzSessionState that rebuilds the Mushaf canvas or card list. Expose high-frequency progress via dedicated Stream<Duration> / ValueNotifier consumed inside isolated StreamBuilder / BlocSelector widgets.
⚬ Checkpoint Auto-Save: Persist user preferences (selected reciter, repeat counts, speed, chaining, pause-to-repeat) and last completed ayah immediately so app kills never lose progress.
  </state_management>

<ui_ux_specifications>
All screens must strictly match Hojaty's RTL Arabic design system, typography, spacing, and theme tokens.

1. Bottom Navigation Integration

⚬ Add a dedicated tab labeled "حِفظي" (with a clean Quran/bookmark-star icon) to the main Bottom Navigation Bar.

2. HifzHubScreen (Main Tab)

⚬ Top AppBar: Title "حِفظي" + Download/Storage Manager icon button (AudioStorageSheet).
⚬ Empty/New-User State vs Active-Plan State:
  ⚬ Hero Card (One-Tap Resume): Displays Streak badge (🔥 X أيام متتالية), Day progress (اليوم 4 من 40), Track title, Today's Wird range (آية 17 ← 22), linear progress bar + percentage, Primary CTA (▶ ابدأ جلسة اليوم), Secondary CTA (👁 اختبر حفظك).
⚬ Review Radar Card (مُثبّت الحفظ): Shown prominently whenever dueReviews.isNotEmpty. Displays due count + estimated time + summary of surahs + [ راجع الآن ] CTA that launches Studio in review/testing mode.
⚬ Curated Tracks Horizontal Carousel: Cards for Al-Baqarah (40 days), Al-Mulk (7 days), Al-Kahf, Juz Amma + + خطة مخصصة button opening TrackSetupSheet.
⚬ Quick Loop Banner (تكرار حر سريع): One-tap launcher to pick any Surah + start/end Ayah and jump directly into HifzStudioScreen without creating a persistent plan.

3. HifzStudioScreen (Full-Screen Distraction-Free)

⚬ Hides Bottom Nav Bar. Automatically enables WakelockPlus.enable() during playing and pausingForRepeat, and disables on pause/dispose.
⚬ Top Header: Back button (minimizes to HifzMiniPlayer if audio is active), Surah & Ayah range title, Segmented Toggle [ بطاقات | مصحف ], Settings icon.
⚬ Live Phase Bar: Shows current mode (حفظ فردي / ربط تراكمي / مراجعة المقطع), Repeat counter (التكرار 3 / 5), and step progress bar.
⚬ Center Viewport (Two Modes):
  1. Focus Card Mode (FocusCardView): Centered high-legibility Quranic card for the active ayah, with previous & next ayahs softly dimmed (30% opacity) above/below. Smooth Scrollable.ensureVisible (300ms) on ayah change. During pausingForRepeat, display an animated RepeatCountdownPill (🎙 دورك للترديد... متبقي X ث) with a تخطي button.
  2. Interactive Mushaf Overlay Mode (MushafOverlayView): Renders Hojaty's existing Mushaf page with animated highlight over the active ayah's bounding boxes, auto-flipping pages (PageController.animateToPage) when the ayah crosses a page boundary.
⚬ Self-Testing Mode (اختبر حفظك — Hide & Reveal):
  ⚬ Masks/blurs all target ayahs (both in Focus Cards and over Mushaf bounding boxes).
  ⚬ First-Word / Audio Hint: Long-press or tap a hint button on a masked ayah to reveal only its first 2 words OR play its first 2 seconds of audio.
  ⚬ Tap a masked ayah to smoothly reveal (AnimatedOpacity) and mark "تم الحفظ ✓" or "أحتاج مراجعة" (feeds directly into ayah_mastery).
⚬ Smart Loop Bottom Dock (SmartLoopDock):
  ⚬ Top row: Reciter selector pill (الحصري المعلم ▾), Speed toggle (0.75x / 1.0x / 1.25x), Eye toggle (👁 إخفاء للتسميع).
  ⚬ Middle row: Ayah Repeat stepper (1x, 3x, 5x, 7x, 10x, ∞), Central Play/Pause FAB, Range Repeat stepper (1x, 2x, 3x, 5x).
  ⚬ Toggle chips: [ 🔗 ربط تراكمي ] and [ 🎙 سكتة ترديد ].
  ⚬ Bottom CTA: [ ✓ أتممت حفظ الورد ] (logs activity, updates streak, schedules Spaced Repetition reviews, shows subtle completion celebration).
⚬ Graceful Offline UX: If offline and an uncached ayah is reached, NEVER crash. Display a calm inline banner: "لا يوجد اتصال لتحميل آية {X} — يمكنك المتابعة في وضع القراءة والتسميع الصامت" with a button to switch immediately to silent testing mode.

4. AudioStorageSheet

⚬ Displays total cached MB, list of downloaded surahs per reciter, offline batch download progress with cancel support, "تنظيف الكاش المؤقت" (clears unpinned files), and per-surah delete.
  </ui_ux_specifications>

<platform_configuration>
Verify and update native configs for production background audio:

1. iOS (ios/Runner/Info.plist): Ensure UIBackgroundModes contains audio.
2. Android (android/app/src/main/AndroidManifest.xml):
  ⚬ Permissions: WAKE_LOCK, FOREGROUND_SERVICE, FOREGROUND_SERVICE_MEDIA_PLAYBACK.
  ⚬ Register com.ryanheise.audioservice.AudioService with android:foregroundServiceType="mediaPlayback" and MediaButtonReceiver per audio_service Android 14+ requirements.
3. Add a bundled silent MP3 file at assets/audio/silence_30s.mp3 (and register it in pubspec.yaml alongside assets/data/hifz_tracks.json).
   </platform_configuration>

<strict_guardrails>

⚬ Zero TODO, mock data, stubbed methods, or skipped edge cases.
⚬ Do not break any existing features, Drift schema versions (write a proper MigrationStrategy.onUpgrade), or Bottom Nav tabs.
⚬ Write unit tests for GlobalAyahMapper, GeneratePlaybackQueue (normal, chaining, infinity, live-mutation snap), and CalculateSpacedReview (Leitner promotion & demotion).
⚬ Run flutter analyze and unit tests at the end and fix all warnings/errors.
  </strict_guardrails>

<execution_plan>
Execute systematically in phases, reporting concise progress after each phase:

⚬ Phase 0: Inspect codebase & state the integration plan (reused Mushaf/Quran sources, Drift DB version, DI, theme).
⚬ Phase 1: Domain entities, GlobalAyahMapper, GeneratePlaybackQueue, CalculateSpacedReview, hifz_tracks.json, and Drift tables + migration + DAOs.
⚬ Phase 2: ReciterRegistry, AudioCacheManager (atomic downloads, fallback, pre-fetcher, LRU), HifzAudioHandler, and HifzSessionOrchestrator (including silent-audio background pause).
⚬ Phase 3: HifzHubCubit, HifzSessionCubit, DI registration.
⚬ Phase 4: HifzHubScreen, HifzStudioScreen (Focus Card + Mushaf Overlay + Hide & Reveal + Smart Loop Dock), TrackSetupSheet, AudioStorageSheet, HifzMiniPlayer, and Bottom Nav tab wiring.
⚬ Phase 5: Platform configs (iOS/Android), unit tests, and full flutter analyze verification.

Start now with Phase 0.
</execution_plan>



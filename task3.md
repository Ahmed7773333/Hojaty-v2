# Task 3 & 4: Self-Updating Adhkar Quick Action & Smart Offline Adhan Settings Search

Inspect the Home screen quick actions, prayer times calculation/state management, and the Settings / Adhan Settings screens first. Follow Clean Architecture and project extensions.

## Part A: Reactive Prayer-Aware Adhkar Quick Action
- **Goal:** The Home screen Adhkar quick action must automatically switch between Morning (*أذكار الصباح*), Evening (*أذكار المساء*), Post-Prayer (*أذكار بعد الصلاة*), and Sleep Adhkar (*أذكار النوم*) as prayer times pass without requiring an app restart.
- **Battery-Safe Implementation (NO `Timer.periodic`):**
  - Calculate the exact `DateTime` of the next prayer boundary in a Domain UseCase.
  - Schedule a single precision `Timer` for `nextBoundary.difference(DateTime.now()) + Duration(seconds: 1)`.
  - Observe `WidgetsBindingObserver` (`AppLifecycleState.resumed`) to immediately recalculate and reschedule when returning from background.
  - Dispose the timer properly in `close()`/`dispose()`.

## Part B: Adhan Settings Direct Entry & Smart Offline Search (No AI)
- **Direct Access:** Keep Adhan Settings in its current Settings location, AND add a prominent external entry point (e.g., a clear settings button/card on the Prayer Times screen or top-level Settings shortcut) so users immediately find it.
- **Pure-Dart Smart Search Engine:**
  - Build a deterministic search bar at the top of Settings / Adhan Settings backed by a structured `SettingSearchItem` index (`titleAr`, `titleEn`, `breadcrumb`, `synonymsAndTags`, `routeOrSectionKey`).
  - Normalize Arabic characters (`أ/إ/آ` -> `ا`, `ة` -> `ه`, `ى` -> `ي`, strip Tashkeel) and map colloquial intents/synonyms (e.g., *"صوت المؤذن"* -> Muezzin audio, *"تقديم/تأخير"* -> Time offsets, *"الفجر مش بيرن"* -> Notification/battery permissions, *"المذهب"* -> Asr calculation).
  - Tapping a result navigates to the target section, auto-scrolls to the exact widget via `GlobalKey`, and flashes a subtle 1.5-second highlight animation.

Output a brief file-by-file plan first, then implement cleanly and run `flutter analyze`.

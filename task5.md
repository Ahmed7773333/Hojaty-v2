# Task 6: Native Home Screen Prayer Countdown Widget (Android & iOS)

Inspect Hojaty's existing Prayer Times domain entities, prayer calculation/caching logic, and the in-app "Next Prayer Countdown Card" UI design first so the home screen widget matches its visual identity. Follow Clean Architecture and project extensions.

## Architectural & Platform Strategy (Battery-Safe Native Countdowns)
Neither Android nor iOS allows Dart/Flutter background isolates to wake up every second to redraw a home screen widget. Both platforms must use **OS-native hardware-accelerated countdown views** driven by the exact target prayer timestamp:

### 1. Flutter Bridge Layer (`home_widget` package)
- Integrate `home_widget` cleanly inside a dedicated `PrayerWidgetService` / Repository in `data` and trigger updates from `domain` whenever:
  1. The app opens or resumes (`AppLifecycleState.resumed`).
  2. User location, calculation method, or manual prayer offsets change.
  3. A prayer time passes (via existing prayer notification/alarm callbacks or background task).
- **Shared App Group / Storage Payload:** Save the following structured data for the native widgets to read:
  - `next_prayer_name_ar` (e.g., `"صلاة العصر"`) & `next_prayer_name_en`
  - `next_prayer_time_formatted` (e.g., `"03:18 م"`)
  - `next_prayer_timestamp_ms` (Exact UTC epoch milliseconds of the next prayer)
  - `location_name` (e.g., `"القاهرة"`)
  - `hijri_date` (Optional brief date label)
- **Deep Link on Tap:** Configure widget tap URI (`hojaty://prayer_times`) so tapping anywhere on the widget launches Hojaty directly into the Prayer Times / Home screen.

### 2. Android Implementation (Kotlin + AppWidgetProvider / Glance)
- Create a sleek, modern RTL-ready Android Home Screen Widget (`4x2` / `4x1` resizable) matching Hojaty's card aesthetics (rounded corners, subtle Islamic gradient/surface, prayer icon, prayer name, formatted Adhan time, and live countdown).
- **Live Seconds Countdown without Battery Drain:**
  - Use Android's native `<Chronometer android:countDown="true" />` bound to `SystemClock.elapsedRealtime() + remainingMillis`. This renders a smooth `HH:MM:SS` live countdown natively on the Android Launcher with zero background CPU wakeups.
- **Automatic Prayer Rollover:**
  - Schedule an exact alarm / `WorkManager` trigger at `next_prayer_timestamp_ms` so that as soon as the countdown hits `00:00:00`, the widget automatically advances to the following prayer (including Fajr of the next day) even if the user hasn't opened the app.
- Register the widget receiver and metadata XML cleanly in `AndroidManifest.xml` (no invasive permissions required).

### 3. iOS Implementation (SwiftUI WidgetKit Extension)
- Create a SwiftUI `WidgetKit` extension (`HojatyPrayerWidget`) supporting `systemMedium` (and optionally `systemSmall`) families using shared `UserDefaults(suiteName: "group.com.wolfdev.hojaty")`.
- **Live Seconds Countdown without Battery Drain:**
  - Use SwiftUI's native `Text(targetDate, style: .timer)` alongside the prayer name and formatted time. iOS natively ticks the `HH:MM:SS` countdown on the Home Screen without waking the app.
- **Timeline Provider (`TimelineProvider`):**
  - Pre-populate timeline entries for all 5 daily prayers (+ next day's Fajr) so WidgetKit transitions automatically from prayer to prayer throughout the entire day offline.
- Ensure the widget honors Hojaty's Liquid Glass / translucent aesthetic where appropriate on iOS.

## Execution & Verification
1. Output a brief file-by-file plan covering Flutter (`lib/`), Android (`android/app/src/main/`), and iOS (`ios/`) files first.
2. Implement cleanly with RTL support, proper fallback UI if prayer times aren't cached yet (*"افتح التطبيق لتحديث المواقيت"*), and verify `flutter analyze` passes with zero errors.

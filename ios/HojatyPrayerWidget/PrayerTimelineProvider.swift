import WidgetKit
import Foundation

struct PrayerTimelineProvider: TimelineProvider {
    func placeholder(in context: Context) -> PrayerWidgetEntry {
        PrayerWidgetEntry.placeholder(isArabic: PrayerWidgetStorage.resolveIsArabic())
    }

    func getSnapshot(in context: Context, completion: @escaping (PrayerWidgetEntry) -> Void) {
        if context.isPreview {
            completion(PrayerWidgetEntry.placeholder(isArabic: PrayerWidgetStorage.resolveIsArabic()))
            return
        }
        let entries = PrayerWidgetStorage.buildTimelineEntries(now: Date())
        completion(entries.first ?? PrayerWidgetEntry.placeholder(isArabic: PrayerWidgetStorage.resolveIsArabic()))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<PrayerWidgetEntry>) -> Void) {
        let now = Date()
        let entries = PrayerWidgetStorage.buildTimelineEntries(now: now)
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

import Foundation
import WidgetKit

struct PrayerScheduleSlot: Codable {
    let key: String
    let nameAr: String
    let nameEn: String
    let timeFormattedAr: String
    let timeFormattedEn: String
    let timestampMs: Int64

    var targetDate: Date {
        Date(timeIntervalSince1970: TimeInterval(timestampMs) / 1000.0)
    }
}

struct PrayerWidgetEntry: TimelineEntry {
    let date: Date
    let prayerKey: String
    let prayerName: String
    let formattedTime: String
    let targetDate: Date
    let locationName: String
    let hijriDate: String
    let isArabic: Bool
    let isFallback: Bool

    static func placeholder(isArabic: Bool = true) -> PrayerWidgetEntry {
        PrayerWidgetEntry(
            date: Date(),
            prayerKey: "asr",
            prayerName: isArabic ? "صلاة العصر" : "Asr",
            formattedTime: isArabic ? "03:18 م" : "03:18 PM",
            targetDate: Date().addingTimeInterval(3600 + 1455),
            locationName: isArabic ? "القاهرة" : "Cairo",
            hijriDate: isArabic ? "12 ربيع الأول 1448 هـ" : "12 Rabi' I 1448 AH",
            isArabic: isArabic,
            isFallback: false
        )
    }

    static func fallback(at date: Date, isArabic: Bool) -> PrayerWidgetEntry {
        PrayerWidgetEntry(
            date: date,
            prayerKey: "fajr",
            prayerName: "",
            formattedTime: "",
            targetDate: date,
            locationName: "",
            hijriDate: "",
            isArabic: isArabic,
            isFallback: true
        )
    }
}

enum PrayerWidgetStorage {
    static let appGroupId = "group.com.wolfdev.hojaty"
    static let deepLinkUrl = URL(string: "hojaty://prayer_times")!

    private static let keyPrayerKey = "prayer_key"
    private static let keyNameAr = "next_prayer_name_ar"
    private static let keyNameEn = "next_prayer_name_en"
    private static let keyTimeFormatted = "next_prayer_time_formatted"
    private static let keyTimestampMs = "next_prayer_timestamp_ms"
    private static let keyLocationName = "location_name"
    private static let keyHijriDate = "hijri_date"
    private static let keyLanguage = "language"
    private static let keyScheduleJson = "prayer_schedule_json"
    private static let keyIsInitialized = "is_initialized"

    private static var defaults: UserDefaults? {
        UserDefaults(suiteName: appGroupId)
    }

    static func resolveIsArabic() -> Bool {
        if let saved = defaults?.string(forKey: keyLanguage), !saved.isEmpty {
            return saved == "ar"
        }
        let preferred = Locale.preferredLanguages.first ?? "ar"
        return !preferred.lowercased().hasPrefix("en")
    }

    static func buildTimelineEntries(now: Date = Date()) -> [PrayerWidgetEntry] {
        let isArabic = resolveIsArabic()
        guard let defaults = defaults, defaults.bool(forKey: keyIsInitialized) else {
            return [PrayerWidgetEntry.fallback(at: now, isArabic: isArabic)]
        }

        let locationName = defaults.string(forKey: keyLocationName) ?? ""
        let hijriDate = defaults.string(forKey: keyHijriDate) ?? ""

        // 1. Prefer full multi-prayer schedule for seamless offline day transitions
        if let jsonString = defaults.string(forKey: keyScheduleJson),
           let data = jsonString.data(using: .utf8),
           let slots = try? JSONDecoder().decode([PrayerScheduleSlot].self, from: data) {
            let upcoming = slots
                .filter { $0.targetDate > now }
                .sorted { $0.timestampMs < $1.timestampMs }

            if !upcoming.isEmpty {
                var entries: [PrayerWidgetEntry] = []
                for (index, slot) in upcoming.enumerated() {
                    let entryDate = index == 0 ? now : upcoming[index - 1].targetDate
                    entries.append(
                        PrayerWidgetEntry(
                            date: entryDate,
                            prayerKey: slot.key,
                            prayerName: isArabic ? slot.nameAr : slot.nameEn,
                            formattedTime: isArabic ? slot.timeFormattedAr : slot.timeFormattedEn,
                            targetDate: slot.targetDate,
                            locationName: locationName,
                            hijriDate: hijriDate,
                            isArabic: isArabic,
                            isFallback: false
                        )
                    )
                }

                // Append fallback entry right after the last cached prayer so timer never counts up
                if let lastTarget = upcoming.last?.targetDate {
                    entries.append(
                        PrayerWidgetEntry.fallback(
                            at: lastTarget.addingTimeInterval(1),
                            isArabic: isArabic
                        )
                    )
                }

                return entries
            }
        }

        // 2. Fallback to flat next-prayer keys
        let tsMs = (defaults.object(forKey: keyTimestampMs) as? NSNumber)?.int64Value ?? 0
        let targetDate = Date(timeIntervalSince1970: TimeInterval(tsMs) / 1000.0)
        guard tsMs > 0, targetDate > now else {
            return [PrayerWidgetEntry.fallback(at: now, isArabic: isArabic)]
        }

        let nameAr = defaults.string(forKey: keyNameAr) ?? ""
        let nameEn = defaults.string(forKey: keyNameEn) ?? ""
        let formattedTime = defaults.string(forKey: keyTimeFormatted) ?? ""
        let prayerKey = defaults.string(forKey: keyPrayerKey) ?? "fajr"

        let activeEntry = PrayerWidgetEntry(
            date: now,
            prayerKey: prayerKey,
            prayerName: isArabic ? nameAr : nameEn,
            formattedTime: formattedTime,
            targetDate: targetDate,
            locationName: locationName,
            hijriDate: hijriDate,
            isArabic: isArabic,
            isFallback: false
        )
        let expiredEntry = PrayerWidgetEntry.fallback(
            at: targetDate.addingTimeInterval(1),
            isArabic: isArabic
        )
        return [activeEntry, expiredEntry]
    }
}

import WidgetKit
import SwiftUI

struct HojatyPrayerWidget: Widget {
    let kind: String = "HojatyPrayerWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: PrayerTimelineProvider()) { entry in
            HojatyPrayerWidgetView(entry: entry)
        }
        .configurationDisplayName("مواقيت الصلاة - حچتي")
        .description("عدّاد تنازلي مباشر لموعد الصلاة القادمة")
        .supportedFamilies([.systemMedium, .systemSmall])
        .contentMarginsDisabledIfAvailable()
    }
}

private extension WidgetConfiguration {
    func contentMarginsDisabledIfAvailable() -> some WidgetConfiguration {
        if #available(iOSApplicationExtension 17.0, *) {
            return self.contentMarginsDisabled()
        }
        return self
    }
}

@main
struct HojatyPrayerWidgetBundle: WidgetBundle {
    var body: some Widget {
        HojatyPrayerWidget()
    }
}

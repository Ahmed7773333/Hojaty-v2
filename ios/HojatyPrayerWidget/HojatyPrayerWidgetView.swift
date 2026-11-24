import SwiftUI
import WidgetKit

struct HojatyPrayerWidgetView: View {
    @Environment(\.widgetFamily) private var family
    let entry: PrayerWidgetEntry

    // Hojaty Brand Palette (matches AppColors & HomeNextPrayerCardWidget)
    private let bgStart = Color(red: 0x16 / 255.0, green: 0x35 / 255.0, blue: 0x32 / 255.0)
    private let bgCenter = Color(red: 0x1B / 255.0, green: 0x3B / 255.0, blue: 0x36 / 255.0)
    private let bgEnd = Color(red: 0x1D / 255.0, green: 0x43 / 255.0, blue: 0x3F / 255.0)
    private let goldLight = Color(red: 0xD8 / 255.0, green: 0xB2 / 255.0, blue: 0x57 / 255.0)
    private let goldAccent = Color(red: 0xCC / 255.0, green: 0xA1 / 255.0, blue: 0x42 / 255.0)
    private let secondaryText = Color(red: 0xA3 / 255.0, green: 0xC4 / 255.0, blue: 0xBE / 255.0)

    var body: some View {
        Group {
            if entry.isFallback {
                fallbackContent
            } else if family == .systemSmall {
                smallContent
            } else {
                mediumContent
            }
        }
        .environment(\.layoutDirection, entry.isArabic ? .rightToLeft : .leftToRight)
        .widgetURL(PrayerWidgetStorage.deepLinkUrl)
        .modifier(HojatyWidgetBackgroundModifier(bgStart: bgStart, bgCenter: bgCenter, bgEnd: bgEnd))
    }

    private var mediumContent: some View {
        VStack(alignment: .leading, spacing: 10) {
            if !entry.locationName.isEmpty || !entry.hijriDate.isEmpty {
                HStack(spacing: 6) {
                    if !entry.locationName.isEmpty {
                        HStack(spacing: 4) {
                            Image(systemName: "location.fill")
                                .font(.system(size: 10, weight: .semibold))
                                .foregroundColor(secondaryText)
                            Text(entry.locationName)
                                .font(.system(size: 11, weight: .medium))
                                .foregroundColor(secondaryText)
                                .lineLimit(1)
                        }
                    }

                    Spacer(minLength: 6)

                    if !entry.hijriDate.isEmpty {
                        Text(entry.hijriDate)
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundColor(goldLight)
                            .lineLimit(1)
                    }
                }
            }

            HStack(alignment: .center, spacing: 12) {
                prayerIconBadge(size: 42, iconSize: 19)

                VStack(alignment: .leading, spacing: 2) {
                    Text(entry.isArabic ? "الصلاة القادمة" : "Next Prayer")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundColor(secondaryText)

                    Text(entry.prayerName)
                        .font(.system(size: 21, weight: .heavy))
                        .foregroundColor(.white)
                        .lineLimit(1)
                        .minimumScaleFactor(0.75)

                    Text(entry.formattedTime)
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(secondaryText)
                        .lineLimit(1)
                }

                Spacer(minLength: 4)

                VStack(alignment: .trailing, spacing: 4) {
                    Text(entry.isArabic ? "المتبقي" : "Remaining")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundColor(goldLight)

                    Text(entry.targetDate, style: .timer)
                        .font(.system(size: 22, weight: .heavy, design: .rounded))
                        .monospacedDigit()
                        .foregroundColor(.white)
                        .multilineTextAlignment(.trailing)
                        .environment(\.layoutDirection, .leftToRight)
                        .lineLimit(1)
                        .minimumScaleFactor(0.75)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
    }

    private var smallContent: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 6) {
                prayerIconBadge(size: 30, iconSize: 14)
                Spacer(minLength: 4)
                if !entry.locationName.isEmpty {
                    Text(entry.locationName)
                        .font(.system(size: 10, weight: .medium))
                        .foregroundColor(secondaryText)
                        .lineLimit(1)
                }
            }

            Spacer(minLength: 2)

            Text(entry.isArabic ? "الصلاة القادمة" : "Next Prayer")
                .font(.system(size: 10, weight: .semibold))
                .foregroundColor(secondaryText)

            Text(entry.prayerName)
                .font(.system(size: 18, weight: .heavy))
                .foregroundColor(.white)
                .lineLimit(1)
                .minimumScaleFactor(0.75)

            Text(entry.formattedTime)
                .font(.system(size: 11, weight: .semibold))
                .foregroundColor(secondaryText)
                .lineLimit(1)

            Text(entry.targetDate, style: .timer)
                .font(.system(size: 19, weight: .heavy, design: .rounded))
                .monospacedDigit()
                .foregroundColor(goldLight)
                .environment(\.layoutDirection, .leftToRight)
                .lineLimit(1)
                .minimumScaleFactor(0.75)
        }
        .padding(14)
    }

    private var fallbackContent: some View {
        VStack(spacing: 8) {
            prayerIconBadge(size: 38, iconSize: 18)
            Text(entry.isArabic ? "افتح التطبيق لتحديث المواقيت" : "Open app to update prayer times")
                .font(.system(size: 13, weight: .bold))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .lineLimit(2)
        }
        .padding(16)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func prayerIconBadge(size: CGFloat, iconSize: CGFloat) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: size * 0.3, style: .continuous)
                .fill(goldAccent.opacity(0.18))
                .overlay(
                    RoundedRectangle(cornerRadius: size * 0.3, style: .continuous)
                        .stroke(goldAccent.opacity(0.35), lineWidth: 1)
                )
            Image(systemName: symbolName(for: entry.prayerKey))
                .font(.system(size: iconSize, weight: .semibold))
                .foregroundColor(goldLight)
        }
        .frame(width: size, height: size)
    }

    private func symbolName(for key: String) -> String {
        switch key {
        case "fajr":
            return "moon.stars.fill"
        case "sunrise":
            return "sunrise.fill"
        case "dhuhr":
            return "sun.max.fill"
        case "asr":
            return "sun.haze.fill"
        case "maghrib":
            return "sunset.fill"
        case "isha":
            return "moon.fill"
        default:
            return "moon.stars.fill"
        }
    }
}

private struct HojatyWidgetBackgroundModifier: ViewModifier {
    let bgStart: Color
    let bgCenter: Color
    let bgEnd: Color

    private var gradientBackground: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [bgStart, bgCenter, bgEnd]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.white.opacity(0.08),
                    Color.clear
                ]),
                startPoint: .topLeading,
                endPoint: .center
            )
        }
    }

    func body(content: Content) -> some View {
        if #available(iOSApplicationExtension 17.0, *) {
            content
                .containerBackground(for: .widget) {
                    gradientBackground
                }
        } else {
            content
                .background(gradientBackground)
        }
    }
}

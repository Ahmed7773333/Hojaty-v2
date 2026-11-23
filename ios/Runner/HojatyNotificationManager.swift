import Flutter
import Foundation
import UserNotifications
import UIKit

class HojatyNotificationManager: NSObject, UNUserNotificationCenterDelegate {
    static let shared = HojatyNotificationManager()

    static let categoryPrayer = "HOJATY_PRAYER_CATEGORY"
    static let categorySalawat = "HOJATY_SALAWAT_CATEGORY"
    static let categoryPrePrayer = "HOJATY_PRE_PRAYER_CATEGORY"
    static let categoryOccasion = "HOJATY_OCCASION_CATEGORY"

    static let actionOpenApp = "ACTION_OPEN_APP"
    static let actionStopAzan = "ACTION_STOP_AZAN"
    static let actionDismiss = "ACTION_DISMISS"

    private let userDefaultsKeySalawat = "hojaty_salawat_enabled"

    func setupNotificationCategories() {
        let center = UNUserNotificationCenter.current()
        center.delegate = self

        let openAction = UNNotificationAction(
            identifier: HojatyNotificationManager.actionOpenApp,
            title: "فتح التطبيق",
            options: [.foreground]
        )

        let stopAction = UNNotificationAction(
            identifier: HojatyNotificationManager.actionStopAzan,
            title: "إيقاف الأذان",
            options: [.destructive]
        )

        let dismissAction = UNNotificationAction(
            identifier: HojatyNotificationManager.actionDismiss,
            title: "حسناً",
            options: []
        )

        let prayerCategory = UNNotificationCategory(
            identifier: HojatyNotificationManager.categoryPrayer,
            actions: [openAction, stopAction],
            intentIdentifiers: [],
            options: [.customDismissAction]
        )

        let salawatCategory = UNNotificationCategory(
            identifier: HojatyNotificationManager.categorySalawat,
            actions: [openAction, dismissAction],
            intentIdentifiers: [],
            options: [.customDismissAction]
        )

        let prePrayerCategory = UNNotificationCategory(
            identifier: HojatyNotificationManager.categoryPrePrayer,
            actions: [openAction, dismissAction],
            intentIdentifiers: [],
            options: [.customDismissAction]
        )

        let occasionCategory = UNNotificationCategory(
            identifier: HojatyNotificationManager.categoryOccasion,
            actions: [openAction, dismissAction],
            intentIdentifiers: [],
            options: [.customDismissAction]
        )

        center.setNotificationCategories([
            prayerCategory,
            salawatCategory,
            prePrayerCategory,
            occasionCategory
        ])
    }

    func requestPermission(completion: @escaping (Bool) -> Void) {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Error requesting notification authorization: \(error)")
            }
            DispatchQueue.main.async {
                if granted {
                    UIApplication.shared.registerForRemoteNotifications()
                }
                completion(granted)
            }
        }
    }

    // MARK: - Scheduling Prayers
    func schedulePrayer(
        id: Int,
        triggerTimeMillis: Int64,
        title: String,
        body: String,
        soundId: String?,
        soundPath: String?
    ) {
        let targetDate = Date(timeIntervalSince1970: Double(triggerTimeMillis) / 1000.0)
        guard targetDate > Date() else { return }

        let content = UNMutableNotificationContent()
        content.title = title.isEmpty ? "حان الآن وقت الصلاة" : title
        content.body = body.isEmpty ? "حي على الصلاة، حي على الفلاح" : body
        content.categoryIdentifier = HojatyNotificationManager.categoryPrayer
        content.sound = UNNotificationSound(named: UNNotificationSoundName("prayer_time_is_close.wav"))
        content.userInfo = [
            "id": id,
            "type": "prayer",
            "soundId": soundId ?? "makka",
            "soundPath": soundPath ?? ""
        ]

        let components = Calendar.current.dateComponents(
            [.year, .month, .day, .hour, .minute, .second],
            from: targetDate
        )
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        let request = UNNotificationRequest(identifier: "prayer_\(id)", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling prayer notification ID \(id): \(error)")
            }
        }
    }

    func cancelAllPrayers() {
        HojatyAzanPlayer.shared.stop()
        HojatyFlipDetector.shared.stop()

        var identifiers: [String] = []
        for id in 100...105 {
            identifiers.append("prayer_\(id)")
        }
        identifiers.append("prayer_999")
        identifiers.append("prayer_996")

        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: identifiers)
    }

    // MARK: - Pre-Prayer Reminders
    func schedulePrePrayer(
        id: Int,
        triggerTimeMillis: Int64,
        title: String,
        body: String
    ) {
        let targetDate = Date(timeIntervalSince1970: Double(triggerTimeMillis) / 1000.0)
        guard targetDate > Date() else { return }

        let content = UNMutableNotificationContent()
        content.title = title.isEmpty ? "اقترب موعد الصلاة" : title
        content.body = body.isEmpty ? "استعد للصلاة" : body
        content.categoryIdentifier = HojatyNotificationManager.categoryPrePrayer
        content.sound = UNNotificationSound(named: UNNotificationSoundName("prayer_time_is_close.wav"))
        content.userInfo = ["id": id, "type": "pre_prayer"]

        let components = Calendar.current.dateComponents(
            [.year, .month, .day, .hour, .minute, .second],
            from: targetDate
        )
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        let request = UNNotificationRequest(identifier: "pre_prayer_\(id)", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request)
    }

    func cancelAllPrePrayers() {
        var identifiers: [String] = []
        for id in 150...155 {
            identifiers.append("pre_prayer_\(id)")
        }
        identifiers.append("pre_prayer_998")
        identifiers.append("pre_prayer_995")

        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: identifiers)
    }

    // MARK: - Salawat Hourly Reminder
    func setSalawatEnabled(_ enabled: Bool) {
        UserDefaults.standard.set(enabled, forKey: userDefaultsKeySalawat)
        let identifier = "salawat_hourly"

        if enabled {
            let content = UNMutableNotificationContent()
            content.title = "الصلاة على النبي ﷺ"
            content.body = "اللهم صلِّ وسلِّم وبارك على سيدنا محمد وعلى آله وصحبه أجمعين"
            content.categoryIdentifier = HojatyNotificationManager.categorySalawat
            content.sound = UNNotificationSound(named: UNNotificationSoundName("salli_ala_muhammad.wav"))
            content.userInfo = ["id": 777, "type": "salawat"]

            // Repeating interval: 3600 seconds (1 hour)
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3600, repeats: true)
            let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)

            UNUserNotificationCenter.current().add(request)
        } else {
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
            UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [identifier])
        }
    }

    // MARK: - Occasions
    func scheduleOccasion(
        id: Int,
        triggerTimeMillis: Int64,
        title: String,
        body: String
    ) {
        let targetDate = Date(timeIntervalSince1970: Double(triggerTimeMillis) / 1000.0)
        guard targetDate > Date() else { return }

        let content = UNMutableNotificationContent()
        content.title = title.isEmpty ? "مناسبة إسلامية" : title
        content.body = body
        content.categoryIdentifier = HojatyNotificationManager.categoryOccasion
        content.sound = .default
        content.userInfo = ["id": id, "type": "occasion"]

        let components = Calendar.current.dateComponents(
            [.year, .month, .day, .hour, .minute, .second],
            from: targetDate
        )
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        let request = UNNotificationRequest(identifier: "occasion_\(id)", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request)
    }

    func cancelAllOccasions() {
        var identifiers: [String] = []
        for id in 200...300 {
            identifiers.append("occasion_\(id * 10 + 1)")
            identifiers.append("occasion_\(id * 10 + 2)")
        }
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: identifiers)
    }

    // MARK: - Test Notifications
    func showTestNotification(soundId: String?, soundPath: String?, title: String, body: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.categoryIdentifier = HojatyNotificationManager.categoryPrayer
        content.sound = UNNotificationSound(named: UNNotificationSoundName("prayer_time_is_close.wav"))
        content.userInfo = ["id": 999, "type": "prayer", "soundId": soundId ?? "", "soundPath": soundPath ?? ""]

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.5, repeats: false)
        let request = UNNotificationRequest(identifier: "prayer_999", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)

        HojatyAzanPlayer.shared.play(soundPath: soundPath, soundId: soundId)
        HojatyFlipDetector.shared.start(notificationId: 999)
    }

    func showTestPreAdhanNotification(title: String, body: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.categoryIdentifier = HojatyNotificationManager.categoryPrePrayer
        content.sound = UNNotificationSound(named: UNNotificationSoundName("prayer_time_is_close.wav"))
        content.userInfo = ["id": 998, "type": "pre_prayer"]

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.5, repeats: false)
        let request = UNNotificationRequest(identifier: "pre_prayer_998", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }

    func showTestSalawatNotification(title: String, body: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.categoryIdentifier = HojatyNotificationManager.categorySalawat
        content.sound = UNNotificationSound(named: UNNotificationSoundName("salli_ala_muhammad.wav"))
        content.userInfo = ["id": 777, "type": "salawat"]

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.5, repeats: false)
        let request = UNNotificationRequest(identifier: "salawat_test", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }

    // MARK: - UNUserNotificationCenterDelegate
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        // Display notification banner, sound, badge, AND keep it in Notification Center list (.list)
        if #available(iOS 14.0, *) {
            completionHandler([.banner, .list, .sound, .badge])
        } else {
            completionHandler([.alert, .sound, .badge])
        }
    }

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        let actionId = response.actionIdentifier
        let userInfo = response.notification.request.content.userInfo
        let notifType = userInfo["type"] as? String

        if actionId == HojatyNotificationManager.actionStopAzan ||
           actionId == HojatyNotificationManager.actionDismiss ||
           actionId == UNNotificationDismissActionIdentifier {
            HojatyAzanPlayer.shared.stop()
            HojatyFlipDetector.shared.stop()
        } else if notifType == "prayer" {
            let soundId = userInfo["soundId"] as? String
            let soundPath = userInfo["soundPath"] as? String
            HojatyAzanPlayer.shared.play(soundPath: soundPath, soundId: soundId)
            HojatyFlipDetector.shared.start(notificationId: userInfo["id"] as? Int)
        }

        completionHandler()
    }
}

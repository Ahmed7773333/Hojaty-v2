import Flutter
import UIKit
import UserNotifications
import AVFoundation

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {

    private static let channelAsset = "com.wolfdev.hojaty/asset_delivery"
    private static let channelCompass = "com.wolfdev.hojaty/compass"
    private static let channelFlip = "com.wolfdev.hojaty/azan_flip"
    private static let channelNotification = "com.wolfdev.hojaty/notifications"
    private static let channelHifzPlatform = "com.wolfdev.hojaty/hifz_platform"

    private var flipMethodChannel: FlutterMethodChannel?
    private var notificationMethodChannel: FlutterMethodChannel?
    private var hifzPlatformChannel: FlutterMethodChannel?
    private var channelsConfigured = false

    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        HojatyNotificationManager.shared.setupNotificationCategories()
        UNUserNotificationCenter.current().delegate = HojatyNotificationManager.shared

        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.playback, mode: .default, options: [])
            try session.setActive(true)
        } catch {
            print("Failed to set AVAudioSession category: \(error)")
        }
        application.beginReceivingRemoteControlEvents()

        let result = super.application(application, didFinishLaunchingWithOptions: launchOptions)

        if let controller = window?.rootViewController as? FlutterViewController {
            setupChannels(messenger: controller.binaryMessenger)
        }

        return result
    }

    func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
        GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
        setupChannels(messenger: engineBridge.applicationRegistrar.messenger())
    }

    func setupChannels(messenger: FlutterBinaryMessenger) {
        guard !channelsConfigured else { return }
        channelsConfigured = true

        // 1. Asset Delivery (On-Demand Resources)
        let assetChannel = FlutterMethodChannel(name: AppDelegate.channelAsset, binaryMessenger: messenger)
        ODRAssetDeliveryHandler.shared.setup(channel: assetChannel)

        // 2. Compass Sensor
        let compassChannel = FlutterEventChannel(name: AppDelegate.channelCompass, binaryMessenger: messenger)
        HojatyCompassHandler.shared.register(channel: compassChannel)

        // 3. Notifications & Alarms Channel
        notificationMethodChannel = FlutterMethodChannel(name: AppDelegate.channelNotification, binaryMessenger: messenger)
        notificationMethodChannel?.setMethodCallHandler { (call, result) in
            let args = call.arguments as? [String: Any]

            switch call.method {
            case "init":
                HojatyNotificationManager.shared.setupNotificationCategories()
                result(true)

            case "requestPermission":
                HojatyNotificationManager.shared.requestPermission { granted in
                    result(granted)
                }

            case "schedulePrayer":
                let id = args?["id"] as? Int ?? 100
                let triggerTimeMillis = (args?["triggerTimeMillis"] as? NSNumber)?.int64Value ?? 0
                let title = args?["title"] as? String ?? ""
                let body = args?["body"] as? String ?? ""
                let soundId = args?["soundId"] as? String
                let soundPath = args?["soundPath"] as? String

                HojatyNotificationManager.shared.schedulePrayer(
                    id: id,
                    triggerTimeMillis: triggerTimeMillis,
                    title: title,
                    body: body,
                    soundId: soundId,
                    soundPath: soundPath
                )
                result(true)

            case "cancelAllPrayers":
                HojatyNotificationManager.shared.cancelAllPrayers()
                result(true)

            case "schedulePrePrayer":
                let id = args?["id"] as? Int ?? 150
                let triggerTimeMillis = (args?["triggerTimeMillis"] as? NSNumber)?.int64Value ?? 0
                let title = args?["title"] as? String ?? ""
                let body = args?["body"] as? String ?? ""

                HojatyNotificationManager.shared.schedulePrePrayer(
                    id: id,
                    triggerTimeMillis: triggerTimeMillis,
                    title: title,
                    body: body
                )
                result(true)

            case "cancelAllPrePrayers":
                HojatyNotificationManager.shared.cancelAllPrePrayers()
                result(true)

            case "scheduleSalawat":
                let enabled = args?["enabled"] as? Bool ?? true
                HojatyNotificationManager.shared.setSalawatEnabled(enabled)
                result(true)

            case "scheduleOccasion":
                let id = args?["id"] as? Int ?? 200
                let triggerTimeMillis = (args?["triggerTimeMillis"] as? NSNumber)?.int64Value ?? 0
                let title = args?["title"] as? String ?? ""
                let body = args?["body"] as? String ?? ""

                HojatyNotificationManager.shared.scheduleOccasion(
                    id: id,
                    triggerTimeMillis: triggerTimeMillis,
                    title: title,
                    body: body
                )
                result(true)

            case "cancelAllOccasions":
                HojatyNotificationManager.shared.cancelAllOccasions()
                result(true)

            case "showTestNotification":
                let soundId = args?["soundId"] as? String
                let soundPath = args?["soundPath"] as? String
                let title = args?["title"] as? String ?? "اختبار تنبيه الصلاة والأذان"
                let body = args?["body"] as? String ?? "حان الآن وقت صلاة الظهر - حي على الصلاة"

                HojatyNotificationManager.shared.showTestNotification(
                    soundId: soundId,
                    soundPath: soundPath,
                    title: title,
                    body: body
                )
                result(true)

            case "showTestPreAdhanNotification":
                let title = args?["title"] as? String ?? "اقترب موعد صلاة الظهر"
                let body = args?["body"] as? String ?? "فاضل 5 دقائق على صلاة الظهر، استعد للصلاة"

                HojatyNotificationManager.shared.showTestPreAdhanNotification(
                    title: title,
                    body: body
                )
                result(true)

            case "showTestSalawatNotification":
                let title = args?["title"] as? String ?? "الصلاة على النبي ﷺ"
                let body = args?["body"] as? String ?? "اللهم صلِّ وسلِّم وبارك على سيدنا محمد وعلى آله وصحبه أجمعين"

                HojatyNotificationManager.shared.showTestSalawatNotification(
                    title: title,
                    body: body
                )
                result(true)

            case "stopAllAudio":
                HojatyAzanPlayer.shared.stop()
                HojatyFlipDetector.shared.stop()
                result(true)

            default:
                result(FlutterMethodNotImplemented)
            }
        }

        // 4. Azan Flip & Native Player Channel
        flipMethodChannel = FlutterMethodChannel(name: AppDelegate.channelFlip, binaryMessenger: messenger)
        flipMethodChannel?.setMethodCallHandler { (call, result) in
            let args = call.arguments as? [String: Any]

            switch call.method {
            case "startFlipDetector":
                let notifId = args?["notificationId"] as? Int
                HojatyFlipDetector.shared.start(notificationId: notifId)
                result(true)

            case "stopFlipDetector":
                HojatyFlipDetector.shared.stop()
                HojatyAzanPlayer.shared.stop()
                result(true)

            case "playAzanNative":
                let soundPath = args?["soundPath"] as? String
                let soundId = args?["soundId"] as? String
                HojatyAzanPlayer.shared.play(soundPath: soundPath, soundId: soundId)
                result(true)

            case "stopAzanNative":
                HojatyAzanPlayer.shared.stop()
                result(true)

            case "isAzanNativePlaying":
                result(HojatyAzanPlayer.shared.isPlaying)

            default:
                result(FlutterMethodNotImplemented)
            }
        }

        // Flip detector callback to Flutter
        HojatyFlipDetector.shared.onAzanStoppedCallback = { [weak self] notifId in
            DispatchQueue.main.async {
                self?.flipMethodChannel?.invokeMethod(
                    "onAzanStoppedByFlip",
                    arguments: ["notificationId": notifId as Any]
                )
            }
        }

        // 5. Hifz Platform Channel (Wakelock & iCloud Backup Exclusion)
        hifzPlatformChannel = FlutterMethodChannel(name: AppDelegate.channelHifzPlatform, binaryMessenger: messenger)
        hifzPlatformChannel?.setMethodCallHandler { (call, result) in
            let args = call.arguments as? [String: Any]
            switch call.method {
            case "setWakelock":
                let enabled = args?["enabled"] as? Bool ?? false
                DispatchQueue.main.async {
                    UIApplication.shared.isIdleTimerDisabled = enabled
                }
                result(true)
            case "excludeFromBackup":
                if let path = args?["path"] as? String {
                    var url = URL(fileURLWithPath: path)
                    var resourceValues = URLResourceValues()
                    resourceValues.isExcludedFromBackup = true
                    do {
                        try url.setResourceValues(resourceValues)
                    } catch {
                        // Ignore if directory does not exist yet
                    }
                }
                result(true)
            default:
                result(FlutterMethodNotImplemented)
            }
        }
    }
}

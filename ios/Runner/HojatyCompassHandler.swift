import Flutter
import Foundation
import CoreLocation
import CoreMotion

class HojatyCompassHandler: NSObject, FlutterStreamHandler, CLLocationManagerDelegate {
    static let shared = HojatyCompassHandler()

    private var locationManager: CLLocationManager?
    private var motionManager: CMMotionManager?
    private var eventSink: FlutterEventSink?

    func register(channel: FlutterEventChannel) {
        channel.setStreamHandler(self)
    }

    // MARK: - FlutterStreamHandler
    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        self.eventSink = events

        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.headingFilter = 1.0

        if CLLocationManager.headingAvailable() {
            locationManager?.startUpdatingHeading()
        } else {
            events(FlutterError(code: "NO_SENSOR", message: "Compass sensor is unavailable", details: nil))
        }

        motionManager = CMMotionManager()
        if let motion = motionManager, motion.isDeviceMotionAvailable {
            motion.deviceMotionUpdateInterval = 0.1
            motion.startDeviceMotionUpdates()
        }

        return nil
    }

    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        locationManager?.stopUpdatingHeading()
        locationManager = nil
        motionManager?.stopDeviceMotionUpdates()
        motionManager = nil
        eventSink = nil
        return nil
    }

    // MARK: - CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        guard let sink = eventSink else { return }

        // Use true heading when available, fallback to magnetic heading
        let heading = newHeading.trueHeading >= 0 ? newHeading.trueHeading : newHeading.magneticHeading

        var pitch: Double = 0.0
        var roll: Double = 0.0

        if let attitude = motionManager?.deviceMotion?.attitude {
            pitch = attitude.pitch * 180.0 / .pi
            roll = attitude.roll * 180.0 / .pi
        }

        let map: [String: Any] = [
            "heading": heading,
            "pitch": pitch,
            "roll": roll,
            "accuracy": Int(newHeading.headingAccuracy)
        ]

        sink(map)
    }

    func locationManagerShouldDisplayHeadingCalibration(_ manager: CLLocationManager) -> Bool {
        return true
    }
}


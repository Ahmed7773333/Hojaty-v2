import Foundation
import CoreMotion
import UIKit

class HojatyFlipDetector: NSObject {
    static let shared = HojatyFlipDetector()

    private let motionManager = CMMotionManager()
    private var isListening = false
    private var currentNotificationId: Int?
    private var wasFaceUpOrNeutral = false
    private var faceDownCount = 0
    private var timeoutTimer: Timer?

    var onAzanStoppedCallback: ((Int?) -> Void)?

    func start(notificationId: Int?) {
        if isListening && currentNotificationId == notificationId {
            return
        }

        stop()

        self.currentNotificationId = notificationId
        self.wasFaceUpOrNeutral = false
        self.faceDownCount = 0

        guard motionManager.isAccelerometerAvailable else {
            print("Accelerometer is unavailable for AzanFlipDetector")
            return
        }

        motionManager.accelerometerUpdateInterval = 0.2
        motionManager.startAccelerometerUpdates(to: .main) { [weak self] (data, error) in
            guard let self = self, let data = data else { return }

            let z = data.acceleration.z

            // On iOS:
            // Flat on table face UP: z ≈ -1.0
            // Flat on table face DOWN: z ≈ +1.0
            // Held upright/in-hand: z is between -0.5 and +0.5
            if z < 0.3 {
                self.wasFaceUpOrNeutral = true
            }

            if self.wasFaceUpOrNeutral && z > 0.75 {
                self.faceDownCount += 1
                if self.faceDownCount >= 2 {
                    // Confirmed flip face down!
                    self.triggerAzanSilenced()
                }
            } else {
                self.faceDownCount = 0
            }
        }

        isListening = true

        // Auto timeout after 4 minutes (240s)
        timeoutTimer = Timer.scheduledTimer(withTimeInterval: 240.0, repeats: false) { [weak self] _ in
            self?.stop()
        }
    }

    func stop() {
        guard isListening else { return }
        isListening = false
        timeoutTimer?.invalidate()
        timeoutTimer = nil
        motionManager.stopAccelerometerUpdates()
        currentNotificationId = nil
    }

    private func triggerAzanSilenced() {
        let notifId = currentNotificationId
        stop()

        // 1. Stop native audio playback
        HojatyAzanPlayer.shared.stop()

        // 2. Trigger subtle haptic confirmation
        let feedback = UIImpactFeedbackGenerator(style: .medium)
        feedback.prepare()
        feedback.impactOccurred()

        // 3. Inform Flutter
        DispatchQueue.main.async { [weak self] in
            self?.onAzanStoppedCallback?(notifId)
        }
    }
}


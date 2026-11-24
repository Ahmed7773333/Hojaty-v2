import Foundation
import AVFoundation

class HojatyAzanPlayer: NSObject, AVAudioPlayerDelegate {
    static let shared = HojatyAzanPlayer()

    private var audioPlayer: AVAudioPlayer?

    var isPlaying: Bool {
        return audioPlayer?.isPlaying ?? false
    }

    func play(soundPath: String?, soundId: String?) {
        stop()

        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.playback, mode: .default, options: [])
            try session.setActive(true)
        } catch {
            print("Failed to configure audio session for Azan: \(error)")
        }

        var player: AVAudioPlayer?

        // 1. Try custom local file path
        if let path = soundPath, !path.isEmpty, FileManager.default.fileExists(atPath: path) {
            let url = URL(fileURLWithPath: path)
            player = try? AVAudioPlayer(contentsOf: url)
        }

        // 2. Try raw bundle resource if custom not found
        if player == nil {
            let resName: String
            switch (soundId ?? "makka").lowercased() {
            case "madina", "madinah":
                resName = "madina_azan"
            case "azan", "traditional":
                resName = "azan"
            case "short_reminder":
                resName = "short_reminder"
            default:
                resName = "makka_azan"
            }

            if let url = Bundle.main.url(forResource: resName, withExtension: "mp3")
                ?? Bundle.main.url(forResource: resName, withExtension: "wav") {
                player = try? AVAudioPlayer(contentsOf: url)
            }
        }

        guard let readyPlayer = player else {
            print("No audio source found for Azan (path: \(soundPath ?? "nil"), soundId: \(soundId ?? "nil"))")
            return
        }

        readyPlayer.delegate = self
        readyPlayer.numberOfLoops = 0
        readyPlayer.prepareToPlay()
        readyPlayer.play()
        self.audioPlayer = readyPlayer
    }

    func stop() {
        audioPlayer?.stop()
        audioPlayer = nil
    }

    // MARK: - AVAudioPlayerDelegate
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        self.audioPlayer = nil
        HojatyFlipDetector.shared.stop()
    }
}


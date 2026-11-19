import Flutter
import Foundation
import UIKit
import QuickLook

class ODRAssetDeliveryHandler: NSObject, UIDocumentInteractionControllerDelegate {
    static let shared = ODRAssetDeliveryHandler()

    private var activeRequests: [String: NSBundleResourceRequest] = [:]
    private var progressTimers: [String: Timer] = [:]
    private var methodChannel: FlutterMethodChannel?
    private var documentInteractionController: UIDocumentInteractionController?

    func setup(channel: FlutterMethodChannel) {
        self.methodChannel = channel
        channel.setMethodCallHandler { [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) in
            self?.handle(call, result: result)
        }
    }

    private func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let args = call.arguments as? [String: Any]
        let packName = args?["packName"] as? String ?? "quran_hafs"

        switch call.method {
        case "getAssetPackStatus":
            getAssetPackStatus(packName: packName, result: result)

        case "startDownload":
            startDownload(packName: packName, result: result)

        case "cancelDownload":
            cancelDownload(packName: packName, result: result)

        case "removeAssetPack":
            removeAssetPack(packName: packName, result: result)

        case "getAssetPackPath":
            let path = resolvePackPath(packName: packName)
            result(path)

        case "openPdf":
            guard let filePath = args?["filePath"] as? String, !filePath.isEmpty else {
                result(FlutterError(code: "INVALID_PATH", message: "File path is required", details: nil))
                return
            }
            openPdf(filePath: filePath, result: result)

        default:
            result(FlutterMethodNotImplemented)
        }
    }

    // MARK: - Status
    private func getAssetPackStatus(packName: String, result: @escaping FlutterResult) {
        // 1. Check if currently downloading
        if let request = activeRequests[packName] {
            let total = request.progress.totalUnitCount
            let downloaded = request.progress.completedUnitCount
            result([
                "status": "DOWNLOADING",
                "isDownloaded": false,
                "assetsPath": NSNull(),
                "bytesDownloaded": downloaded,
                "totalBytes": total
            ])
            return
        }

        // 2. Check local fallback or already downloaded path
        if let existingPath = resolvePackPath(packName: packName) {
            result([
                "status": "COMPLETED",
                "isDownloaded": true,
                "assetsPath": existingPath,
                "bytesDownloaded": 0,
                "totalBytes": 0
            ])
            return
        }

        // 3. Check On-Demand Resources local availability
        let tags: Set<String> = [packName]
        let request = NSBundleResourceRequest(tags: tags)
        request.conditionallyBeginAccessingResources { [weak self] (isAvailable) in
            DispatchQueue.main.async {
                if isAvailable {
                    let path = self?.resolvePackPath(packName: packName) ?? Bundle.main.bundlePath
                    result([
                        "status": "COMPLETED",
                        "isDownloaded": true,
                        "assetsPath": path,
                        "bytesDownloaded": 0,
                        "totalBytes": 0
                    ])
                } else {
                    result([
                        "status": "NOT_INSTALLED",
                        "isDownloaded": false,
                        "assetsPath": NSNull(),
                        "bytesDownloaded": 0,
                        "totalBytes": 0
                    ])
                }
            }
        }
    }

    // MARK: - Download
    private func startDownload(packName: String, result: @escaping FlutterResult) {
        if activeRequests[packName] != nil {
            result(true)
            return
        }

        let tags: Set<String> = [packName]
        let request = NSBundleResourceRequest(tags: tags)
        request.loadingPriority = NSBundleResourceRequestLoadingPriorityUrgent
        activeRequests[packName] = request

        // Start progress observation
        let timer = Timer.scheduledTimer(withTimeInterval: 0.25, repeats: true) { [weak self] _ in
            guard let self = self, let req = self.activeRequests[packName] else { return }
            let completed = req.progress.completedUnitCount
            let total = req.progress.totalUnitCount

            self.methodChannel?.invokeMethod("onDownloadProgress", arguments: [
                "packName": packName,
                "status": "DOWNLOADING",
                "bytesDownloaded": completed,
                "totalBytes": total,
                "assetsPath": NSNull(),
                "errorCode": NSNull()
            ])
        }
        progressTimers[packName] = timer

        request.beginAccessingResources { [weak self] (error) in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.progressTimers[packName]?.invalidate()
                self.progressTimers.removeValue(forKey: packName)

                if let error = error as NSError? {
                    self.activeRequests.removeValue(forKey: packName)
                    self.methodChannel?.invokeMethod("onDownloadProgress", arguments: [
                        "packName": packName,
                        "status": "FAILED",
                        "bytesDownloaded": 0,
                        "totalBytes": 0,
                        "assetsPath": NSNull(),
                        "errorCode": error.code
                    ])
                } else {
                    let finalPath = self.resolvePackPath(packName: packName) ?? Bundle.main.bundlePath
                    self.methodChannel?.invokeMethod("onDownloadProgress", arguments: [
                        "packName": packName,
                        "status": "COMPLETED",
                        "bytesDownloaded": request.progress.totalUnitCount,
                        "totalBytes": request.progress.totalUnitCount,
                        "assetsPath": finalPath,
                        "errorCode": NSNull()
                    ])
                }
            }
        }

        result(true)
    }

    // MARK: - Cancel
    private func cancelDownload(packName: String, result: @escaping FlutterResult) {
        progressTimers[packName]?.invalidate()
        progressTimers.removeValue(forKey: packName)

        if let request = activeRequests[packName] {
            request.progress.cancel()
            activeRequests.removeValue(forKey: packName)
        }

        methodChannel?.invokeMethod("onDownloadProgress", arguments: [
            "packName": packName,
            "status": "CANCELED",
            "bytesDownloaded": 0,
            "totalBytes": 0,
            "assetsPath": NSNull(),
            "errorCode": NSNull()
        ])

        result(true)
    }

    // MARK: - Remove
    private func removeAssetPack(packName: String, result: @escaping FlutterResult) {
        if let request = activeRequests[packName] {
            request.endAccessingResources()
            activeRequests.removeValue(forKey: packName)
        }

        // Clean local documents fallback folder if exists
        let fileManager = FileManager.default
        if let docsUrl = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
            let packFolder = docsUrl.appendingPathComponent("asset_packs").appendingPathComponent(packName)
            if fileManager.fileExists(atPath: packFolder.path) {
                try? fileManager.removeItem(at: packFolder)
            }
        }

        result(true)
    }

    // MARK: - Resolve Path
    private func resolvePackPath(packName: String) -> String? {
        let fileManager = FileManager.default

        // 1. Check inside Bundle.main subfolder
        if let subBundlePath = Bundle.main.path(forResource: packName, ofType: nil),
           fileManager.fileExists(atPath: subBundlePath) {
            return subBundlePath
        }

        // 2. Check active request bundle
        if let req = activeRequests[packName],
           let reqPath = req.bundle.path(forResource: packName, ofType: nil),
           fileManager.fileExists(atPath: reqPath) {
            return reqPath
        }

        // 3. Check App Documents / asset_packs / <packName>
        if let docsUrl = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
            let localPackFolder = docsUrl.appendingPathComponent("asset_packs").appendingPathComponent(packName)
            if fileManager.fileExists(atPath: localPackFolder.path),
               let items = try? fileManager.contentsOfDirectory(atPath: localPackFolder.path),
               !items.isEmpty {
                return localPackFolder.path
            }
        }

        // 4. Check if files for this pack exist directly in Bundle.main resourcePath
        if let resourcePath = Bundle.main.resourcePath {
            let directFolder = (resourcePath as NSString).appendingPathComponent(packName)
            if fileManager.fileExists(atPath: directFolder) {
                return directFolder
            }
        }

        return nil
    }

    // MARK: - Open PDF
    private func openPdf(filePath: String, result: @escaping FlutterResult) {
        let fileUrl = URL(fileURLWithPath: filePath)
        guard FileManager.default.fileExists(atPath: filePath) else {
            result(FlutterError(code: "NOT_FOUND", message: "PDF file does not exist", details: nil))
            return
        }

        guard let rootViewController = UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.rootViewController else {
            result(FlutterError(code: "NO_WINDOW", message: "Could not find root view controller", details: nil))
            return
        }

        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.documentInteractionController = UIDocumentInteractionController(url: fileUrl)
            self.documentInteractionController?.delegate = self
            let previewPresented = self.documentInteractionController?.presentPreview(animated: true) ?? false

            if !previewPresented {
                // Fallback to Open In menu
                self.documentInteractionController?.presentOptionsMenu(from: rootViewController.view.bounds, in: rootViewController.view, animated: true)
            }
            result(true)
        }
    }

    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.rootViewController ?? UIViewController()
    }
}


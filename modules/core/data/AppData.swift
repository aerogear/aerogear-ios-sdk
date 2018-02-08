import Foundation

public class AppData {

    private let defaults = UserDefaults.standard

    public var metadata: AgsMetaData!

    init() {
        let bundleId = Bundle.main.bundleIdentifier ?? "Unknown"
        let instalId = setupInstallationId()
        let appVersion = setupAppVersion()
        metadata = AgsMetaData(installationId: instalId, appVersion: appVersion, bundleId: bundleId)
    }

    private func setupInstallationId() -> String {
        if let installId = defaults.string(forKey: "metrics-sdk-installation-id") {
            return installId
        } else {
            let installId = UUID().uuidString
            defaults.set(installId, forKey: "metrics-sdk-installation-id")
            AgsCore.logger.debug("Generated new client id: \(installId)")
            return installId
        }
    }

    private func setupAppVersion() -> String {
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            return version
        } else {
            return "Unknown"
        }
    }
}

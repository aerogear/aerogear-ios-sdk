import Foundation

public class AppData {
    private let defaults = UserDefaults.standard

    public var metadata: AgsMetaData!

    init() {
        let bundleId = Bundle.main.bundleIdentifier ?? "Unknown"
        let clientId = setupClientId()
        let appVersion = setupAppVersion()
        metadata = AgsMetaData(clientId: clientId, appVersion: appVersion, bundleId: bundleId)
    }

    private func setupClientId() -> String {
        if let clientId = defaults.string(forKey: "metrics-sdk-client-id") {
            return clientId
        } else {
            let clientId = UUID().uuidString
            defaults.set(clientId, forKey: "metrics-sdk-client-id")
            AgsCore.logger.debug("Generated new client id: \(clientId)")
            return clientId
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

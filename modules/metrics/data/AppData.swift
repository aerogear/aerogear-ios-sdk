import AGSCore
import Foundation

/**
 * Holds static application data that can be used for metrics
 */
public class AppData {

    private let defaults = UserDefaults.standard

    // Application installation id
    public var installationID: String!

    // Application version
    public var appVersion: String!

    // Application bundle id (org.example.app etc.)
    public let bundleId: String!

    init() {
        bundleId = Bundle.main.bundleIdentifier ?? "Unknown"
        setupInstallationId()
        setupAppVersion()
    }

    private func setupInstallationId() {
        if let versionId = defaults.string(forKey: "metrics-sdk-installation-id") {
            installationID = versionId
        } else {
            let uuid = UUID().uuidString
            installationID = uuid
            defaults.set(installationID, forKey: "metrics-sdk-installation-id")
            AgsCore.logger.debug("Generated new client id: \(installationID)")
        }
    }

    private func setupAppVersion() {
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            appVersion = version
        } else {
            appVersion = "Unknown"
        }
    }
}

import Foundation

/**
 * AeroGear Mobile Services Configuration
 * Responsible for parsing and processing configuration for individual services.
 */
public class Config {

    let configFileName: String
    var config: MobileConfig

    init(_ configFileName: String = "mobile-services") {
        self.configFileName = configFileName
        config = MobileConfig()
        readConfiguration()
    }

    public func getConfiguration(_ serviceRef: String) -> [MobileService] {
        return config.services.filter { $0.name == serviceRef }
    }

    public subscript(serviceRef: String) -> [MobileService] {
        return getConfiguration(serviceRef)
    }

    private func readConfiguration() {
        let jsonData = ConfigParser.readLocalJsonData(configFileName)
        guard let data = jsonData else {
            return
        }
        let decoder = JSONDecoder()
        do {
            config = try decoder.decode(MobileConfig.self, from: data)
        } catch {
            AgsCoreLogger.logger().error("Error when decoding configuration file. Cannot decode \(configFileName)")
        }
    }
}

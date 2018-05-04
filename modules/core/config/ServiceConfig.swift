import Foundation

/**
 AeroGear Mobile Services Configuration
 Entrypoint for parsing and processing configuration for individual services.

 This class is responsible for providing configurations for services of certain types.
 Configuration is stored in single json file
 that contains multiple individual service configurations and metadata.
 Service developers can query configuration for certain types.
 See top level core interface for more information

 - Example usage:
 `config['myServiceType']`
 */
public class ServiceConfig {
    let configFileName: String
    var config: MobileConfig?

    public init(_ configFileName: String = "mobile-services") {
        self.configFileName = configFileName
        readConfiguration()
    }

    /**
     Fetch configuration for specific type

     - Parameter type: type of the service to fetch
     - return: MobileService array
     */
    public func getConfigurationByType(_ type: String) -> [MobileService] {
        if let config = config {
            return config.services.filter { $0.type == type }
        } else {
            return []
        }
    }

    /**
     Fetch configuration for specific id
     Should be used for elements that can appear multiple times in the config

     - Parameter id: unique id of the service
     - return: MobileService
     */
    public func getConfigurationById(_ id: String) -> MobileService? {
        if let config = config {
            return config.services.first { $0.id == id }
        }
        return nil
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
            AgsCore.logger.error("Error when decoding configuration file. Cannot decode \(configFileName). Error = \(error.localizedDescription)")
        }
    }
}

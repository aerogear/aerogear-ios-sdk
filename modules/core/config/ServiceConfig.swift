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
     Fetch single service configuration from configuration files.

     - return: MobileService instance or nil if service cannot be found
     */
    public subscript(serviceRef: String) -> MobileService? {
        let configuration = getConfiguration(serviceRef)
        if configuration.count > 1 {
            AgsCore.logger.warning("""
             Mobile configuration \(configFileName) contains more than one service of the same type.
             Using configuration from the first occurence of service with that type.
             Any other duplicate will be ignored.
             Please review your \(configFileName) for services with \(serviceRef) type.
            """)
        } else if configuration.count == 0 {
            AgsCore.logger.error("""
            Configuration  \(configFileName) is missing service \(serviceRef) configuration
            Please review your \(configFileName) for services with \(serviceRef) type.
            """)
            return nil
        }
        return configuration.first
    }

    /**
     Fetch configuration for specific type

     - return: MobileService array
     */
    public func getConfiguration(_ serviceRef: String) -> [MobileService] {
        if let config = config {
            return config.services.filter { $0.id == serviceRef }
        } else {
            return []
        }
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

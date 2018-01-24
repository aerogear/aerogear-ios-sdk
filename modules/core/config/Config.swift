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
        self.config = MobileConfig()
        self.readConfiguration()
    }

    public func getConfiguration(_ serviceRef: String) -> [MobileService]? {
        // FIXME: change filter to use type instead of name once service format will be finalized
        // TODO optional handling
        return config.services!.filter { $0.name == serviceRef }
    }
    

    private func readConfiguration() {
        ConfigParser.readLocalJsonData(configFileName) { data, _ in
            guard let data = data else {
                return
            }
            let decoder = JSONDecoder()
            do {
                self.config = try decoder.decode(MobileConfig.self, from: data)
            } catch let e {
                // FIXME: use logger
                // FIXME: propagate error to library
                print("failed to convert \(e)")
            }
        }
    }
}

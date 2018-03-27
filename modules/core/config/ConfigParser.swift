import Foundation

/**
   Static helper class responsible for parsing mobile configuration
 */
public final class ConfigParser {
    /**
       Helper method for reading json file
     */
    public static func readLocalJsonData(_ resource: String) -> Data? {
        var data: Data?
        AgsCore.logger.debug("Parsing configuration \(resource)")
        if let filePath = Bundle.main.path(forResource: resource, ofType: "json") {
            let url = URL(fileURLWithPath: filePath)
            do {
                data = try Data(contentsOf: url, options: .uncached)
            } catch {
                AgsCore.logger.error("Invalid contents. Cannot read \(resource) from \(filePath)")
            }
        } else {
            AgsCore.logger.error("Missing \(resource)? Please make sure that file is added to Xcode project")
        }
        return data
    }
}

import Foundation

/**
 * Static helper class responsible for parsing mobile configuration
 */
public final class ConfigParser {

    /**
     * Helper method for reading json file
     */
    public static func readLocalJsonData(_ resource: String, completion: @escaping (_ data: Data?, _ error: Error?) -> Void) {
        DispatchQueue.global(qos: .background).async {
            let filePath = Bundle.main.path(forResource: resource, ofType: "json")
            let url = URL(fileURLWithPath: filePath!)
            let data = try! Data(contentsOf: url, options: .uncached)
            completion(data, nil)
        }
    }
}

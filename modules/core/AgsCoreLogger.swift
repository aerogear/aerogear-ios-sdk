import Foundation
import XCGLogger

/**
 * SDK debug logger used for internal logging purposes.
 * Developers and SDK users can manage loggers on service level by changing format, disabling enabling logging etc.
 * Logging based on https://github.com/DaveWoodCom/XCGLogger
 */
public class AgsCoreLogger {
    public static let instance = AgsCoreLogger()

    public static func logger() -> XCGLogger {
        return instance.defaultLogger
    }

    public let defaultLogger: XCGLogger = {
        // Create logger only when needed
        let log = XCGLogger(identifier: "main", includeDefaultDestinations: true)
        log.setup(level: .debug, showThreadName: false, showLevel: true, showFileNames: true, showLineNumbers: true)
        return log
    }()
}

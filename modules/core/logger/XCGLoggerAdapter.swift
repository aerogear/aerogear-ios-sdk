import Foundation
import XCGLogger

/**
 * SDK debug logger used for internal logging purposes.
 * Developers and SDK users can manage loggers on service level by changing format, disabling enabling logging etc.
 * Class implements AgsLoggable for https://github.com/DaveWoodCom/XCGLogger
 */
open class XCGLoggerAdapter: AgsLoggable {

    let defaultLoggerInstance: XCGLogger

    init(_ instance: XCGLogger) {
        defaultLoggerInstance = instance
    }

    /**
     * Log something at the verbose log level.
     *
     * @param closure  A closure that returns the object to be logged. It can be any object like string, array etc.
     * @param userInfo Dictionary for adding arbitrary data to the log message, can be used by filters/formatters etc
     */
     // swiftlint:disable line_length
    open override func verbose(functionName: StaticString = #function, fileName: StaticString = #file, lineNumber: Int = #line, _ closure: @autoclosure () -> Any?) {
        defaultLoggerInstance.logln(closure, level: .verbose, functionName: functionName, fileName: fileName, lineNumber: lineNumber)
    }

    /**
     * Log something at the debug log level.
     *
     * @param closure     A closure that returns the object to be logged. It can be any object like string, array etc.
     * @param userInfo Dictionary for adding arbitrary data to the log message, can be used by filters/formatters etc
     */
     // swiftlint:disable line_length
    open override func debug(functionName: StaticString = #function, fileName: StaticString = #file, lineNumber: Int = #line, _ closure: @autoclosure () -> Any?) {
        defaultLoggerInstance.logln(closure, level: .debug, functionName: functionName, fileName: fileName, lineNumber: lineNumber)
    }

    /**
     * Log something at the info log level.
     *
     * @param closure     A closure that returns the object to be logged. It can be any object like string, array etc.
     * @param userInfo Dictionary for adding arbitrary data to the log message, can be used by filters/formatters etc
     */
    // swiftlint:disable line_length
    open override func info(functionName: StaticString = #function, fileName: StaticString = #file, lineNumber: Int = #line, _ closure: @autoclosure () -> Any?) {
        defaultLoggerInstance.logln(closure, level: .info, functionName: functionName, fileName: fileName, lineNumber: lineNumber)
    }

    /**
     * Log something at the warning log level.
     *
     * @param closure     A closure that returns the object to be logged. It can be any object like string, array etc.
     * @param userInfo Dictionary for adding arbitrary data to the log message, can be used by filters/formatters etc
     */
    open override func warning(functionName: StaticString = #function, fileName: StaticString = #file, lineNumber: Int = #line, _ closure: @autoclosure () -> Any?) {
        defaultLoggerInstance.logln(closure, level: .warning, functionName: functionName, fileName: fileName, lineNumber: lineNumber)
    }

    /**
     * Log something at the error log level.
     *
     * @param closure     A closure that returns the object to be logged. It can be any object like string, array etc.
     * @param userInfo Dictionary for adding arbitrary data to the log message, can be used by filters/formatters etc
     */
     // swiftlint:disable line_length
    open override func error(functionName: StaticString = #function, fileName: StaticString = #file, lineNumber: Int = #line, _ closure: @autoclosure () -> Any?) {
        defaultLoggerInstance.logln(closure, level: .error, functionName: functionName, fileName: fileName, lineNumber: lineNumber)
    }

    /**
     * Log something at the severe log level.
     *
     * @param closure     A closure that returns the object to be logged. It can be any object like string, array etc.
     * @param userInfo Dictionary for adding arbitrary data to the log message, can be used by filters/formatters etc
     */
     // swiftlint:disable line_length
    open override func severe(functionName: StaticString = #function, fileName: StaticString = #file, lineNumber: Int = #line, _ closure: @autoclosure () -> Any?) {
        defaultLoggerInstance.logln(closure, level: .severe, functionName: functionName, fileName: fileName, lineNumber: lineNumber)
    }
}

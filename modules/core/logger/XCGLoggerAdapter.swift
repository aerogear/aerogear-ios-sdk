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
    open func verbose(_ closure: @autoclosure () -> Any?) {
        defaultLoggerInstance.logln(closure, level: .verbose)
    }

    /**
     * Log something at the debug log level.
     *
     * @param closure     A closure that returns the object to be logged. It can be any object like string, array etc.
     * @param userInfo Dictionary for adding arbitrary data to the log message, can be used by filters/formatters etc
     */
    open func debug(_ closure: @autoclosure () -> Any?) {
        defaultLoggerInstance.logln(closure, level: .debug)
    }

    /**
     * Log something at the info log level.
     *
     * @param closure     A closure that returns the object to be logged. It can be any object like string, array etc.
     * @param userInfo Dictionary for adding arbitrary data to the log message, can be used by filters/formatters etc
     */
    open func info(_ closure: @autoclosure () -> Any?) {
        defaultLoggerInstance.logln(closure, level: .info)
    }

    /**
     * Log something at the warning log level.
     *
     * @param closure     A closure that returns the object to be logged. It can be any object like string, array etc.
     * @param userInfo Dictionary for adding arbitrary data to the log message, can be used by filters/formatters etc
     */
    open func warning(_ closure: @autoclosure () -> Any?) {
        defaultLoggerInstance.logln(closure, level: .warning)
    }

    /**
     * Log something at the error log level.
     *
     * @param closure     A closure that returns the object to be logged. It can be any object like string, array etc.
     * @param userInfo Dictionary for adding arbitrary data to the log message, can be used by filters/formatters etc
     */
    open func error(_ closure: @autoclosure () -> Any?) {
        defaultLoggerInstance.logln(closure, level: .error)
    }

    /**
     * Log something at the severe log level.
     *
     * @param closure     A closure that returns the object to be logged. It can be any object like string, array etc.
     * @param userInfo Dictionary for adding arbitrary data to the log message, can be used by filters/formatters etc
     */
    open func severe(_ closure: @autoclosure () -> Any?) {
        defaultLoggerInstance.logln(closure, level: .severe)
    }
}

import Foundation

/**
 * Protocol for all classes that want to provide logging functionality
 */
public protocol AgsLoggable {

    /**
     * Log something at the verbose log level.
     *
     * @param closure  A closure that returns the object to be logged.
     * It can be any object like string, array etc.
     */
    func verbose(_ closure: @autoclosure () -> Any?)

    /**
     * Log something at the debug log level.
     *
     * @param closure  A closure that returns the object to be logged.
     * It can be any object like string, array etc.
     */
    func debug(_ closure: @autoclosure () -> Any?)

    /**
     * Log something at the info log level.
     *
     * @param closure  A closure that returns the object to be logged.
     * It can be any object like string, array etc.
     */
    func info(_ closure: @autoclosure () -> Any?)

    /**
     * Log something at the warning log level.
     *
     * @param closure  A closure that returns the object to be logged.
     * It can be any object like string, array etc.
     */
    func warning(_ closure: @autoclosure () -> Any?)

    /**
     * Log something at the error log level.
     *
     * @param closure  A closure that returns the object to be logged.
     * It can be any object like string, array etc.
     */
    func error(_ closure: @autoclosure () -> Any?)

    /**
     * Log something at the severe log level.
     *
     * @param closure  A closure that returns the object to be logged.
     * It can be any object like string, array etc.
     */
    func severe(_ closure: @autoclosure () -> Any?)
}

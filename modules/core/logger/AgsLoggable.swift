import Foundation

/**
 Class that should be extende by all implementations that want to provide logging functionality
 Note: This class is moved from protocol because
 logger interface requires to provide default values for line numbers etc.
 Class can be also used to disable SDK logging
 */
open class AgsLoggable {
    /**
     Log something at the verbose log level.

     - Parameter closure: A closure that returns the object to be logged.
     It can be any object like string, array etc.
     */
    open func verbose(functionName _: StaticString = #function, fileName _: StaticString = #file, lineNumber _: Int = #line, _: @autoclosure () -> Any?) {
        // Intentionally empty. See implementations
    }

    /**
     Log something at the debug log level.

     - Parameter closure: A closure that returns the object to be logged.
     It can be any object like string, array etc.
     */
    open func debug(functionName _: StaticString = #function, fileName _: StaticString = #file, lineNumber _: Int = #line, _: @autoclosure () -> Any?) {
        // Intentionally empty. See implementations
    }

    /**
     Log something at the info log level.
     *
     - Parameter closure:   A closure that returns the object to be logged.
     It can be any object like string, array etc.
     */
    open func info(functionName _: StaticString = #function, fileName _: StaticString = #file, lineNumber _: Int = #line, _: @autoclosure () -> Any?) {
        // Intentionally empty. See implementations
    }

    /**
     Log something at the warning log level.

     - Parameter closure: A closure that returns the object to be logged.
     It can be any object like string, array etc.
     */
    open func warning(functionName _: StaticString = #function, fileName _: StaticString = #file, lineNumber _: Int = #line, _: @autoclosure () -> Any?) {
        // Intentionally empty. See implementations
    }

    /**
     Log something at the error log level.
     *
     - Parameter closure: A closure that returns the object to be logged.
     It can be any object like string, array etc.
     */
    open func error(functionName _: StaticString = #function, fileName _: StaticString = #file, lineNumber _: Int = #line, _: @autoclosure () -> Any?) {
        // Intentionally empty. See implementations
    }

    /**
     Log something at the severe log level.

     - Parameter closure: A closure that returns the object to be logged.
     It can be any object like string, array etc.
     */
    open func severe(functionName _: StaticString = #function, fileName _: StaticString = #file, lineNumber _: Int = #line, _: @autoclosure () -> Any?) {
        // Intentionally empty. See implementations
    }
}

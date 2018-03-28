import Foundation
import XCGLogger

/**
 SDK debug logger used for internal logging purposes.
 Developers and SDK users can manage loggers on service level by changing format, disabling enabling logging etc.
 Class implements AgsLoggable for https://github.com/DaveWoodCom/XCGLogger
 */
open class XCGLoggerAdapter: AgsLoggable {
    let defaultLoggerInstance: XCGLogger

    init(_ instance: XCGLogger) {
        defaultLoggerInstance = instance
    }

    /**
     Log something at the verbose log level.

     - Parameter closure: A closure that returns the object to be logged. It can be any object like string, array etc.
     */
    // swiftlint:disable line_length
    open override func verbose(functionName: StaticString = #function, fileName: StaticString = #file, lineNumber: Int = #line, _ closure: @autoclosure () -> Any?) {
        defaultLoggerInstance.logln(closure, level: .verbose, functionName: functionName, fileName: fileName, lineNumber: lineNumber)
    }

    /**
     Log something at the debug log level.

     - Parameter closure: A closure that returns the object to be logged. It can be any object like string, array etc.
     */
    // swiftlint:disable line_length
    open override func debug(functionName: StaticString = #function, fileName: StaticString = #file, lineNumber: Int = #line, _ closure: @autoclosure () -> Any?) {
        defaultLoggerInstance.logln(closure, level: .debug, functionName: functionName, fileName: fileName, lineNumber: lineNumber)
    }

    /**
     Log something at the info log level.

     - Parameter closure: A closure that returns the object to be logged. It can be any object like string, array etc.
     */
    // swiftlint:disable line_length
    open override func info(functionName: StaticString = #function, fileName: StaticString = #file, lineNumber: Int = #line, _ closure: @autoclosure () -> Any?) {
        defaultLoggerInstance.logln(closure, level: .info, functionName: functionName, fileName: fileName, lineNumber: lineNumber)
    }

    /**
     Log something at the warning log level.

     - Parameter closure:    A closure that returns the object to be logged. It can be any object like string, array etc.
     */
    open override func warning(functionName: StaticString = #function, fileName: StaticString = #file, lineNumber: Int = #line, _ closure: @autoclosure () -> Any?) {
        defaultLoggerInstance.logln(closure, level: .warning, functionName: functionName, fileName: fileName, lineNumber: lineNumber)
    }

    /**
     Log something at the error log level.

     - Parameter closure:    A closure that returns the object to be logged. It can be any object like string, array etc.
     */
    // swiftlint:disable line_length
    open override func error(functionName: StaticString = #function, fileName: StaticString = #file, lineNumber: Int = #line, _ closure: @autoclosure () -> Any?) {
        defaultLoggerInstance.logln(closure, level: .error, functionName: functionName, fileName: fileName, lineNumber: lineNumber)
    }

    /**
     Log something at the severe log level.

     - Parameter closure: A closure that returns the object to be logged. It can be any object like string, array etc.
     */
    // swiftlint:disable line_length
    open override func severe(functionName: StaticString = #function, fileName: StaticString = #file, lineNumber: Int = #line, _ closure: @autoclosure () -> Any?) {
        defaultLoggerInstance.logln(closure, level: .severe, functionName: functionName, fileName: fileName, lineNumber: lineNumber)
    }
}

import Foundation

/**
   Represents single metrics data
   We use Any as type to be able to use Array and Dictionary
 */
public typealias MetricsData =  Any

/**
   Root object that is being sent to server
 */
public typealias MetricsRoot = [String: Any]

/**
   Protocol for classes that can publish or store metrics payload
 */
public protocol MetricsPublisher {
    /**
       Allows to publish metrics to external source
       - parameter payload: metrics payload containing all data to be sent
       - parameter handler: closure called when publish operation finished
     */
    func publish(_ payload: MetricsRoot, _ handler: @escaping (AgsHttpResponse?) -> Void)
}

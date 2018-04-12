import Foundation

/**
   Represents single metrics data
 */
public typealias MetricsData = [String: Any]

/**
   Protocol for classes that can publish or store metrics payload
 */
public protocol MetricsPublisher {
    /**
       Allows to publish metrics to external source
       - parameter payload: metrics payload containing all data to be sent
       - parameter handler: closure called when publish operation finished
     */
    func publish(_ payload: MetricsData, _ handler: @escaping (AgsHttpResponse?) -> Void)
}

import Foundation

/**
 * Protocol used for for classes that will colect metrics
 */
public protocol Collectable {

    /**
     * Function called when metrics need to be collected
     */
    func collect()
}

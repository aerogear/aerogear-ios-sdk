import Foundation

public struct UnifiedPushCredentials {
    let variantID: String
    let variantSecret: String

    public init(_ variantID: String, _ variantSecret: String) {
        self.variantID = variantID
        self.variantSecret = variantSecret
    }
}

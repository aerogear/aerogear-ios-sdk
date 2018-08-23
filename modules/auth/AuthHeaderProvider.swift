import Foundation
import AGSCore

/**
  Header provider for the Authorization header
 */
public class AuthHeaderProvider: HeaderProvider {
    
    static let HEADER_TYPE = "Bearer "
    static let HEADER_KEY = "Authorization"
    
    let auth: AgsAuth
    
    public init(_ auth: AgsAuth) {
        self.auth = auth
    }
    
    public func getHeaders() -> [String: String] {
        do {
            let currentUser = try self.auth.currentUser()
            if let token = currentUser?.accessToken {
                return [AuthHeaderProvider.HEADER_KEY: AuthHeaderProvider.HEADER_TYPE + token]
            }
        } catch {
            // Intentionally empty when user is not logged in
        }
        return [:]
    }
}

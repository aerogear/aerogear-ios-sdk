import AGSCore
import Foundation

/**
  Header provider for the Authorization header
 */
public class AuthHeaderProvider: HeaderProvider {

    static let headerType = "Bearer "
    static let headerKey = "Authorization"

    let auth: AgsAuth

    public init(_ auth: AgsAuth) {
        self.auth = auth
    }

    public func getHeaders() -> [String: String] {
        do {
            let currentUser = try self.auth.currentUser()
            if let token = currentUser?.accessToken {
                return [AuthHeaderProvider.headerKey: AuthHeaderProvider.headerType + token]
            }
        } catch {
            // Intentionally empty when user is not logged in
        }
        return [:]
    }
}

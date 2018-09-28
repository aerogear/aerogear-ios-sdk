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

    /**
     Gets the header to be used to perform HTTP requests.
     If needed, the `accessToken` will be automatically refreshed and the callback will be always called with a fresh token
     */
    public func getHeaders(completionHandler: @escaping ([String: String]) -> Void ) -> Void {
        do {
            try self.auth.currentUser(autoRefresh: true) { (currentUser, error) in
                if let token = currentUser?.accessToken {
                    completionHandler([AuthHeaderProvider.headerKey: AuthHeaderProvider.headerType + token])
                    return
                } else {
                    completionHandler([:])
                }
            }
        } catch {
            // Intentionally empty when user is not logged in
            completionHandler([:])

        }
    }
}

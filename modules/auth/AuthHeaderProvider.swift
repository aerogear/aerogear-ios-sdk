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
     If the accessToken needs to be updated, this method will synchronously make the request, blocking until the result is received.
     */
    public func getHeaders() -> [String: String] {
        var result: [String: String]? = nil
        let group = DispatchGroup()
        group.enter()
        
        getHeaders() { headers in
            result = headers
            group.leave()
        }
        
        group.wait()
        
        return result!
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
                }
            }
        } catch {
            // Intentionally empty when user is not logged in
            completionHandler([:])
        }
    }
}

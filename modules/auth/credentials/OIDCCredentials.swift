//
//  OIDCCredentials
//  AGSAuth

import AppAuth
import Foundation

class OIDCCredentials {
    let authState: OIDAuthState

    init(state: OIDAuthState) {
        authState = state
    }

    func getAccessToken() -> String? {
        return nil
    }
}

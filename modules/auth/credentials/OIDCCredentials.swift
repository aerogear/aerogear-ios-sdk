//
//  OIDCCredentials
//  AGSAuth

import Foundation
import AppAuth

class OIDCCredentials {
    let authState: OIDAuthState

    init(state: OIDAuthState) {
        authState = state
    }

    func getAccessToken() -> String? {
        return nil
    }
}

//
//  TokenLifecycleManager.swift
//  AGSAuth
//
//  Created by Massimiliano Ziccardi on 24/09/2018.
//

import Foundation
import AppAuth

public class TokenLifecycleManager {
    public static func refreshAsync(tokenRequest: OIDTokenRequest, completionHandler: @escaping (OIDTokenResponse?, Error?) -> Void) {
        let urlRequest = tokenRequest.urlRequest()
        
        var request = URLRequest(url: urlRequest.url!)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let postString = "scope=\(tokenRequest.scope!)&refresh_token=\(tokenRequest.refreshToken!)&grant_type=\(tokenRequest.grantType)&client_id=\(tokenRequest.clientID)"
        request.httpBody = postString.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                completionHandler(nil, OIDErrorUtilities.error(with: OIDErrorCode.networkError, underlyingError: error, description: "Network error"))
                return
            }
            
//            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode >= 200 && httpStatus.statusCode < 300 {           // check for http errors
//                print("statusCode should be 200, but is \(httpStatus.statusCode)")
//                print("response = \(response)")
//            }
            
            //let responseString = String(data: data, encoding: .utf8)
            do {
                let json = try JSONSerialization.jsonObject(with: data) as! [String: NSCopying]
                if let error = json["error"] as? String {
                    completionHandler(nil, OIDErrorUtilities.oAuthError(withDomain: error, oAuthResponse: json, underlyingError: nil))
                    return
                }
                
                let res = OIDTokenResponse(request: tokenRequest, parameters: [ "access_token": json["access_token"] as! NSString,
                                                                                "id_token": json["id_token"] as! NSString,
                                                                                "expires_in": json["expires_in"] as! NSNumber,
                                                                                "token_type": json["token_type"] as! NSNumber ]  )
                
                completionHandler(res, nil)
                return
                
            } catch let parsingError {
                completionHandler(nil, OIDErrorUtilities.error(with: OIDErrorCode.jsonDeserializationError, underlyingError: parsingError, description: "JSON deserialization error"))
                return
            }
        }
        task.resume()
    }
}

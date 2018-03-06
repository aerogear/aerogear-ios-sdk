//
//  Jwt.swift
//  AGSAuth

import Foundation

struct JSONWebToken {
    let header: String
    let payload: Data
    let signature: String
}

func base64Decode(_ input: String) -> Data? {
    var base64 = input
        .replacingOccurrences(of: "-", with: "+")
        .replacingOccurrences(of: "_", with: "/")
    
    if base64.count % 4 != 0 {
        base64.append(String(repeating: "=", count: 4 - base64.count % 4))
    }
    return Data(base64Encoded: base64)
}

class Jwt {
    enum Errors: Error {
        case InvalidToken(String)
    }
    
    static public func decode(_ jwt: String) throws -> JSONWebToken {
        let parts = jwt.components(separatedBy: ".")
        if parts.count != 3 {
            throw Errors.InvalidToken("wrong segements")
        }
        let headerValue = parts[0]
        let payloadValue = parts[1]
        let signatureValue = parts[2]
        
        let payload = base64Decode(payloadValue)
        
        guard let _ = payload else {
            throw Errors.InvalidToken("can not decode payload")
        }
        
        return JSONWebToken(header: headerValue, payload: payload!, signature: signatureValue)
    }
}



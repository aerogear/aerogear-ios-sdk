import Foundation

/** Represents a JSON Web Token. */
struct JSONWebToken {
    let header: String
    let payload: Data
    let signature: String
}

/**
 Converts a string to base64 encoded data.

 - parameters:
    - input: the string to be converted

 - returns: a base64 encoded version of the `input`
 */
func base64Decode(_ input: String) -> Data? {
    var base64 = input
        .replacingOccurrences(of: "-", with: "+")
        .replacingOccurrences(of: "_", with: "/")

    if base64.count % 4 != 0 {
        base64.append(String(repeating: "=", count: 4 - base64.count % 4))
    }
    return Data(base64Encoded: base64)
}

/**
 Responible for decoding JWT strings.

 - ToDo: use a proper library and add verification.
 */
class Jwt {
    /** Represetns errors that can occur while decoding a JWT */
    enum Errors: Error {
        case invalidToken(String)
    }

    /**
     Decodes a JSON Web Token.

     - parameters:
        - jwt: the JSON Web Token string to be decoded

     - throws: an `invalidToken` token error if the JWT is malformed

     - returns: `JSONWebToken`
     */
    public static func decode(_ jwt: String) throws -> JSONWebToken {
        let parts = jwt.components(separatedBy: ".")
        if parts.count != 3 {
            throw Errors.invalidToken("wrong segements")
        }
        let headerValue = parts[0]
        let payloadValue = parts[1]
        let signatureValue = parts[2]

        let payload = base64Decode(payloadValue)

        guard let _ = payload else {
            throw Errors.invalidToken("can not decode payload")
        }

        return JSONWebToken(header: headerValue, payload: payload!, signature: signatureValue)
    }
}

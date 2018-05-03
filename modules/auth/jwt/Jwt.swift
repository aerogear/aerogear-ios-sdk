import Foundation
import KTVJSONWebToken

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

/** Describes the header of a JSON Web Token */
public struct JwtHeader: Codable {
    public let alg: String
    public let typ: String
    public let kid: String
}

/** Responible for decoding and verifying Json Web Tokens. */
class Jwt {
    /** Represetns errors that can occur while decoding or validating a JWT */
    enum Errors: Error {
        case invalidToken(String)
        case noRSAKeyFound(String)
        case invalidModulus(String)
        case invalidExponent(String)
        case generatingPublicKey(String, Error)
    }

    /**
     Decodes a JSON Web Token.

     - parameters:
        - jwt: the JSON Web Token string to be decoded

     - throws: an `invalidToken` token error if the JWT is malformed

     - returns: `JSONWebToken`
     */
    public static func decode(_ jwt: String) throws -> JSONWebToken {
        do {
            return try JSONWebToken(string: jwt)
        } catch {
            throw Errors.invalidToken("Error decoding JWT")
        }
    }

    /**
     Verifies a JSON Web Token.

     - parameters:
        - jwks: the JSON Web Key Set to verify the JWT against
        - jwt: the JSON Web Token to be verified

     - throws: an `invalidModulus` error if the decoded modulus is nil, an `invalidExponent` error if the decoded exponent is nil or a `generatingPublicKey` error if the RSA public key could not be generated

     - returns: true if the JWT is valid, false otherwise
     */
    public static func verifyJwt(jwks: Jwks, jwt: String) throws -> Bool {
        let jwt = try Jwt.decode(jwt)
        let jwtHeaderData = jwt.decodedDataForPart(JSONWebToken.Part.header)
        let jwtHeader = try JSONDecoder().decode(JwtHeader.self, from: jwtHeaderData)

        guard let jwk = rsaJwk(jwks: jwks, kid: jwtHeader.kid) else {
            throw Errors.noRSAKeyFound("Could not find RSA JSON Web Key from JSON Web Key Set provided")
        }
        guard let modulus = base64Decode(jwk.n) else {
            throw Errors.invalidModulus("Decoded modulus cannot be nil")
        }
        guard let exponent = base64Decode(jwk.e) else {
            throw Errors.invalidExponent("Decoded exponent cannot be nil")
        }

        do {
            let publicKey: RSAKey = try RSAKey.registerOrUpdateKey(modulus: modulus, exponent: exponent, tag: "publicKey")

            let validator = RegisteredClaimValidator.expiration &
                RegisteredClaimValidator.notBefore.optional &
                RSAPKCS1Verifier(key: publicKey, hashFunction: .sha256)

            let validationResult = validator.validateToken(jwt)

            if validationResult.isValid {
                return true
            } else {
                return false
            }
        } catch RSAKey.KeyUtilError.badKeyFormat {
            throw Errors.generatingPublicKey("Error creating RSA public Key using the provided modulus and exponent", RSAKey.KeyUtilError.badKeyFormat)
        }
    }
}

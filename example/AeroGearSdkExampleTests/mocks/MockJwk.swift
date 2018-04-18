//
//  MockJwk.swift
//  AeroGearSdkExampleTests
//

import AGSAuth
import Foundation

func getMockJwks() -> [String: Any] {
    let jwks = [
        "keys": [
            "alg": "RS256",
            "kty": "RSA",
            "use": "sig",
            "n": "kr1fDOUrTZc1MnpY9brGiA7Cz6X1nX77pmrUEgnMq2mxU7ibSW0CAk5e5a4wkmLGYf8EyvaFPHT1fMrFmDK03oN8Q2anh-3e894cXBXazHzzaJD-Lz1HfOOZFeInkAasxWSo8KN1-Kg-1Z7QyrPLhfcbIwfH2Stabx-3lfEMtPGws7tqWg93piA8is1PwIV5_8k4CqLe7jNtUyYS4BKR07oBY6VVxXOKKQAQ3ToLN--sjfaXAjDuE1Go7iW9q7Yt6q9qu4JCX-k6IWu68y_H6cicLXwS1VXPMwFjDOj7cQZB7A3t4q0F-6NVL-t7UjrAAK_7V3lPB-rDwHO92iwlZw",
            "e": "AQAB",
            "kid": "adSoyXNAgQxV43eqHSiRZf6hN9ytvBNQyb2fFSdCTVM"
        ]
    ]
    return jwks
}

func getMockJwksData() -> Jwks {
    let jwksData =
        """
        {
        "keys": [
        {
        "alg": "RS256",
        "kty": "RSA",
        "use": "sig",
        "n": "kr1fDOUrTZc1MnpY9brGiA7Cz6X1nX77pmrUEgnMq2mxU7ibSW0CAk5e5a4wkmLGYf8EyvaFPHT1fMrFmDK03oN8Q2anh-3e894cXBXazHzzaJD-Lz1HfOOZFeInkAasxWSo8KN1-Kg-1Z7QyrPLhfcbIwfH2Stabx-3lfEMtPGws7tqWg93piA8is1PwIV5_8k4CqLe7jNtUyYS4BKR07oBY6VVxXOKKQAQ3ToLN--sjfaXAjDuE1Go7iW9q7Yt6q9qu4JCX-k6IWu68y_H6cicLXwS1VXPMwFjDOj7cQZB7A3t4q0F-6NVL-t7UjrAAK_7V3lPB-rDwHO92iwlZw",
        "e": "AQAB",
        "kid": "adSoyXNAgQxV43eqHSiRZf6hN9ytvBNQyb2fFSdCTVM"
        }
        ]}
        """.data(using: .utf8)!
    return try! JSONDecoder().decode(Jwks.self, from: jwksData)
}

func getMockMalformedModulusJwksData() -> Jwks {
    let malformedModulusJwksData =
        """
        {
        "keys": [
        {
        "alg": "RS256",
        "kty": "RSA",
        "use": "sig",
        "n": "kr1fDOUrTZc1MnpY9brGiA7Cz6X1nX77pmrUEgnMq2mxU7ibSW0CAk5e5a4wkmLGYf8EyvaFPHT1fMrFmDK03oN8Q2anh-3e894cXBXazHzzaJD-Lz1HfOOZFeInkAasxWSo8KN1-Kg-1Z7QyfH2Stabx-3lfEMtPGws7tqWg93piA8is1PwIV5_8k4CqLe7jNtUyYS4BKR07oBY6VVxXOKKQAQ3ToLN--sjfaXAjDuE1Go7iW9q7Yt6q9qu4JCX-k6IWu68y_H6cicLXwS1VXPMwFjDOj7cQZB7A3t4q0F-6NVL-t7UjrAAK_7V3lPB-rDwHO92iwlZw",
        "e": "AQAB",
        "kid": "adSoyXNAgQxV43eqHSiRZf6hN9ytvBNQyb2fFSdCTVM"
        }
        ]}
        """.data(using: .utf8)!
    return try! JSONDecoder().decode(Jwks.self, from: malformedModulusJwksData)
}

func getMockMalformedExponentJwksData() -> Jwks {
    let malformedExponentJwksData =
        """
        {
        "keys": [
        {
        "alg": "RS256",
        "kty": "RSA",
        "use": "sig",
        "n": "kr1fDOUrTZc1MnpY9brGiA7Cz6X1nX77pmrUEgnMq2mxU7ibSW0CAk5e5a4wkmLGYf8EyvaFPHT1fMrFmDK03oN8Q2anh-3e894cXBXazHzzaJD-Lz1HfOOZFeInkAasxWSo8KN1-Kg-1Z7QyrPLhfcbIwfH2Stabx-3lfEMtPGws7tqWg93piA8is1PwIV5_8k4CqLe7jNtUyYS4BKR07oBY6VVxXOKKQAQ3ToLN--sjfaXAjDuE1Go7iW9q7Yt6q9qu4JCX-k6IWu68y_H6cicLXwS1VXPMwFjDOj7cQZB7A3t4q0F-6NVL-t7UjrAAK_7V3lPB-rDwHO92iwlZw",
        "e": "AQ@B",
        "kid": "adSoyXNAgQxV43eqHSiRZf6hN9ytvBNQyb2fFSdCTVM"
        }
        ]}
        """.data(using: .utf8)!
    return try! JSONDecoder().decode(Jwks.self, from: malformedExponentJwksData)
}

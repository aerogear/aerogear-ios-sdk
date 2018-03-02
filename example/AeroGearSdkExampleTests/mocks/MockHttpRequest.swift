//
//  MockHttpRequest.swift
//  AeroGearSdkExampleTests
//

import AGSCore
import Foundation

enum MockHttpErrors: Error {
    case NetworkError
}

class MockHttpRequest: AgsHttpRequestProtocol {
    var dataForGet: Any?
    var errorForGet: Error?
    var dataForPost: Any?
    var errorForPost: Error?
    var dataForPut: Any?
    var errorForPut: Error?
    var dataForDelete: Any?
    var errorForDelete: Error?

    func get(_: String, params _: [String: AnyObject]?, headers _: [String: String]?, _ handler: @escaping (Any?, Error?) -> Void) {
        if let err = errorForGet {
            handler(nil, err)
        } else {
            handler(dataForGet, nil)
        }
    }

    func post(_: String, body _: [String: Any]?, headers _: [String: String]?, _ handler: @escaping (Any?, Error?) -> Void) {
        if let err = errorForPost {
            handler(nil, err)
        } else {
            handler(dataForPost, nil)
        }
    }

    func put(_: String, body _: [String: Any]?, headers _: [String: String]?, _ handler: @escaping (Any?, Error?) -> Void) {
        if let err = errorForPut {
            handler(nil, err)
        } else {
            handler(dataForPut, nil)
        }
    }

    func delete(_: String, headers _: [String: String]?, _ handler: @escaping (Any?, Error?) -> Void) {
        if let err = errorForDelete {
            handler(nil, err)
        } else {
            handler(dataForDelete, nil)
        }
    }
}

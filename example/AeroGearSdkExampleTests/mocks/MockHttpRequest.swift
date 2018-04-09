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

    func get(_: String, params _: [String: AnyObject]?, headers _: [String: String]?, _ handler: @escaping (AgsHttpResponse) -> Void) {
        if let err = errorForGet {
            handler(AgsHttpResponse(error: err))
        } else {
            handler(AgsHttpResponse(response: dataForGet))
        }
    }

    func post(_: String, body _: [String: Any]?, headers _: [String: String]?, _ handler: @escaping (AgsHttpResponse) -> Void) {
        if let err = errorForPost {
            handler(AgsHttpResponse(error: err))
        } else {
            handler(AgsHttpResponse(response: dataForPost))
        }
    }

    func put(_: String, body _: [String: Any]?, headers _: [String: String]?, _ handler: @escaping (AgsHttpResponse) -> Void) {
        if let err = errorForPut {
            handler(AgsHttpResponse(error: err))
        } else {
            handler(AgsHttpResponse(response: dataForPut))
        }
    }

    func delete(_: String, headers _: [String: String]?, _ handler: @escaping (AgsHttpResponse) -> Void) {
        if let err = errorForDelete {
            handler(AgsHttpResponse(error: err))
        } else {
            handler(AgsHttpResponse(response: dataForDelete))
        }
    }
}

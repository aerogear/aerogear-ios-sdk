//
//  MockHttpRequest.swift
//  AeroGearSdkExampleTests
//
//  Created by Wei Li on 01/03/2018.
//  Copyright © 2018 AeroGear. All rights reserved.
//

import Foundation
import AGSCore

enum  MockHttpErrors : Error {
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
    
    func get(_ url: String, params: [String : AnyObject]?, headers: [String : String]?, _ handler: @escaping (Any?, Error?) -> Void) {
        if let err = errorForGet {
            handler(nil, err)
        } else {
            handler(dataForGet, nil)
        }
    }
    
    func post(_ url: String, body: [String : Any]?, headers: [String : String]?, _ handler: @escaping (Any?, Error?) -> Void) {
        if let err = errorForPost {
            handler(nil, err)
        } else {
            handler(dataForPost, nil)
        }
    }
    
    func put(_ url: String, body: [String : Any]?, headers: [String : String]?, _ handler: @escaping (Any?, Error?) -> Void) {
        if let err = errorForPut {
            handler(nil, err)
        } else {
            handler(dataForPut, nil)
        }
    }
    
    func delete(_ url: String, headers: [String : String]?, _ handler: @escaping (Any?, Error?) -> Void) {
        if let err = errorForDelete {
            handler(nil, err)
        } else {
            handler(dataForDelete, nil)
        }
    }
}


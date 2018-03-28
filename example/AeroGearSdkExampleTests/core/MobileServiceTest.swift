//
//  MobileServiceTest.swift
//  AeroGearSdkExampleTests
//
//

@testable import AGSCore
import XCTest

class MobileServiceTest: XCTestCase {
    static let example = "example"
    static let exampleService = "exampleService"
    static let exampleType = "exampleType"
    static let exampleUrl = "http://example.com"
    static let configString = "this is a string"
    static let configInt = 1
    static let configBool = true
    static let configDouble: Double = 2.1
    static let configAnotherDouble: Double = 2.0

    let mobileServiceData = """
    {
        "id": "\(example)",
        "name": "\(exampleService)",
        "type": "\(exampleType)",
        "url": "\(exampleUrl)",
        "config": {
            "string": "\(configString)",
            "int": \(configInt),
            "bool": \(configBool),
            "double": \(configDouble),
            "double2": \(configAnotherDouble)
        }
    }
    """.data(using: .utf8)!

    var mobileServiceToTest: MobileService?

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        mobileServiceToTest = try? JSONDecoder().decode(MobileService.self, from: mobileServiceData)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testParse() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertEqual(mobileServiceToTest!.id, MobileServiceTest.example)
        XCTAssertEqual(mobileServiceToTest!.type, MobileServiceTest.exampleType)
        XCTAssertEqual(mobileServiceToTest!.name, MobileServiceTest.exampleService)
        XCTAssertEqual(mobileServiceToTest!.url, MobileServiceTest.exampleUrl)
        let serviceConfig = mobileServiceToTest!.config!
        XCTAssertEqual(serviceConfig["string"]!.getString()!, MobileServiceTest.configString)
        XCTAssertEqual(serviceConfig["int"]!.getInt()!, MobileServiceTest.configInt)
        XCTAssertEqual(serviceConfig["bool"]!.getBool()!, MobileServiceTest.configBool)
        XCTAssertEqual(serviceConfig["double"]!.getDouble()!, MobileServiceTest.configDouble)
        XCTAssertEqual(serviceConfig["double2"]!.getDouble()!, MobileServiceTest.configAnotherDouble)
    }
}

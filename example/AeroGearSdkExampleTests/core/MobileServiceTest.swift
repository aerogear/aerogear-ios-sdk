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
    static let configDouble2: Double = 2.0
    static let arrayValues = [1];
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
            "double2": \(configDouble2),
            "nestedObject": {
            },
            "array": \(arrayValues)
        }
    }
    """.data(using: .utf8)!

    var mobileServiceToTest: MobileService?

    override func setUp() {
        super.setUp()
        mobileServiceToTest = try? JSONDecoder().decode(MobileService.self, from: mobileServiceData)
    }

    override func tearDown() {
        super.tearDown()
    }

    func testParse() {
        XCTAssertEqual(mobileServiceToTest!.id, MobileServiceTest.example)
        XCTAssertEqual(mobileServiceToTest!.type, MobileServiceTest.exampleType)
        XCTAssertEqual(mobileServiceToTest!.name, MobileServiceTest.exampleService)
        XCTAssertEqual(mobileServiceToTest!.url, MobileServiceTest.exampleUrl)
    }
    
    func testParseTypes() {
        let serviceConfig = mobileServiceToTest!.config!
        XCTAssertEqual(serviceConfig["string"]!.getString()!, MobileServiceTest.configString)
        XCTAssertEqual(serviceConfig["int"]!.getInt()!, MobileServiceTest.configInt)
        XCTAssertEqual(serviceConfig["bool"]!.getBool()!, MobileServiceTest.configBool)
        XCTAssertEqual(serviceConfig["double"]!.getDouble()!, MobileServiceTest.configDouble)
        XCTAssertEqual(serviceConfig["double2"]!.getDouble()!, MobileServiceTest.configDouble2)
    }
    
    func testParseNestedObj() {
        let serviceConfig = mobileServiceToTest!.config!
        let nestedObject = serviceConfig["nestedObject"]?.getObject();
        XCTAssertNotNil(nestedObject)
    }
    
    func testParseArray() {
        let serviceConfig = mobileServiceToTest!.config!
        let array = serviceConfig["array"]!.getArray()!;
        XCTAssertEqual(array[0].getInt(), MobileServiceTest.arrayValues[0])
    }
}

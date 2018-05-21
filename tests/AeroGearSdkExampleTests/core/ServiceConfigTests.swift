

@testable import AGSCore
import Foundation
import XCTest

class ServiceConfigTests: XCTestCase {
    let validServiceName = "keycloak"
    let invalidServiceName = "platform"

    var config: ServiceConfig!

    override func setUp() {
        super.setUp()
        config = ServiceConfig()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testConfigReading() {
        XCTAssertNotNil(config.getConfigurationByType(validServiceName))
    }

    func testConfigParsingInValidService() {
        XCTAssertTrue(config.getConfigurationByType(invalidServiceName).count == 0)
    }

    func testConfigParsingGetById() {
        XCTAssertNotNil(config.getConfigurationById(validServiceName))
    }

    func testConfigParsingGetByIdInvalid() {
        XCTAssertNil(config.getConfigurationById(invalidServiceName))
    }
}

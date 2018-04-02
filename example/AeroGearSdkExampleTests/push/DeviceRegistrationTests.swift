import AGSPush
import UIKit
import XCTest

class AgsPushTests: XCTestCase {
    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testRegistrationWithServerShouldWork() {
        let request: MockHttpRequest = MockHttpRequest()
        // async test expectation
        let registrationExpectation = expectation(description: "UPS registration")

        // attemp to register
        AgsPush.instance.register(
                clientInfo: { (config: ClientDeviceInformation!) in

            // setup configuration
            config.deviceToken = "2c948a843e6404dd013e79d82e5a0009".data(using: String.Encoding.utf8) // dummy token
            config.variantID = "8bd6e6a3-df6b-466c-8292-ed062f2427e8"
            config.variantSecret = "1c9a6066-e0e5-4bcb-ab78-994335f59874"

            // apply the token, to identify THIS device
            let currentDevice = UIDevice()

            // set some 'useful' hardware information params
            config.operatingSystem = currentDevice.systemName
            config.osVersion = currentDevice.systemVersion
            config.deviceType = currentDevice.model
        },

        success: {
            registrationExpectation.fulfill()
        },

        failure: { (error: NSError!) in
            XCTAssertTrue(false, "should have register")

            registrationExpectation.fulfill()
        })

        waitForExpectations(timeout: 10, handler: nil)
    }

    func testRegistrationWithServerShouldFail() {
        let request: MockHttpRequest = MockHttpRequest()
        request.errorForPost = MockHttpErrors.NetworkError
        // async test expectation
        let registrationExpectation = expectation(description: "UPS registration")

        // attemp to register
        AgsPush.instance.register(clientInfo: { (config: ClientDeviceInformation!) in

            // setup configuration
            config.deviceToken = "2c948a843e6404dd013e79d82e5a0009".data(using: String.Encoding.utf8) // dummy token
            config.variantID = "8bd6e6a3-df6b-466c-8292-ed062f2427e8"
            config.variantSecret = "1c9a6066-e0e5-4bcb-ab78-994335f59874"

            // apply the token, to identify THIS device
            let currentDevice = UIDevice()

            // set some 'useful' hardware information params
            config.operatingSystem = currentDevice.systemName
            config.osVersion = currentDevice.systemVersion
            config.deviceType = currentDevice.model
        },

        success: {
            XCTAssertTrue(false, "should fail")
            registrationExpectation.fulfill()
        },

        failure: { (error: NSError!) in
            registrationExpectation.fulfill()
        })

        waitForExpectations(timeout: 10, handler: nil)
    }
}

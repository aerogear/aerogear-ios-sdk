@testable import AGSCore
@testable import AGSPush
import UIKit
import XCTest

class AgPushTests: XCTestCase {
    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testRegistrationWithServerShouldWork() {
        let registrationExpectation = expectation(description: "UPS registration")
        let config = AgsCore.instance.getConfiguration("push")

        let deviceToken = "2c948a843e6404dd013e79d82e5a0009".data(using: String.Encoding.utf8)
        let request: MockHttpRequest = MockHttpRequest()
        let push = AgsPush(config, request)
        // attemp to register
        do {
            try push.register(
                deviceToken!,
                UnifiedPushConfig(),
                success: {
                    registrationExpectation.fulfill()
                },
                failure: { (error: Error!) in
                    XCTAssertTrue(false, "should have register")

                    registrationExpectation.fulfill()
            })

            waitForExpectations(timeout: 10, handler: nil)
        } catch {}
    }

    func testRegistrationWithServerShouldFail() {
        let registrationExpectation = expectation(description: "UPS registration")

        let deviceToken = "2c948a843e6404dd013e79d82e5a0009".data(using: String.Encoding.utf8)

        do {
            try AgsPush.instance.register(
                deviceToken!,
                UnifiedPushConfig(),

                success: {
                    XCTAssertTrue(false, "should fail")
                    registrationExpectation.fulfill()
                },

                failure: { (error: Error) in
                    registrationExpectation.fulfill()
            })

            waitForExpectations(timeout: 10, handler: nil)
        } catch {}
    }
}


@testable import AGSCore
import Foundation
import XCTest

class MetricsIntegrationTests: XCTestCase {

    let metrics = AgsCore.instance.getMetrics()

    func testPublishingDefaultMetricsShouldNotReturnError() {
        let expectation = XCTestExpectation(description: "Getting Success statusCode from App Metrics after sending device and app metrics")

        metrics.publish("init", [DeviceMetrics(), AppMetrics(AgsCore.getMetadata())], { (response: AgsHttpResponse?) -> Void in

            XCTAssertNil(response?.error, "Expecting no error from response after sending valid metrics")

            if let statusCode = response?.statusCode {
                XCTAssert(statusCode < 300, "Expecting returned statusCode to be success (2xx), but it was \(statusCode)")
            }
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 10.0)
    }
}

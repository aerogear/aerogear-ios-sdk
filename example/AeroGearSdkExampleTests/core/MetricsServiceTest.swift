@testable import AGSCore
import Foundation
import XCTest

class MetricsServiceTest: XCTestCase {
    func testMetricsPresent() {
        let metrics: MetricsPublishable = AgsCore.instance.getMetrics()
        XCTAssertNotNil(metrics)
    }

    func testDeviceMetrics() {
        let metrics: DeviceMetrics = DeviceMetrics()
        XCTAssert(metrics.identifier == "device")
        let data: MetricsData = metrics.collect()
        XCTAssertNotNil(data["platform"])
        XCTAssertNotNil(data["platformVersion"])
        XCTAssertNotNil(data["device"])
    }

    func testAppMetrics() {
        let metrics: AppMetrics = AppMetrics(AgsCore.getMetadata())
        let data: MetricsData = metrics.collect()
        XCTAssertNotNil(data["appId"])
        XCTAssertNotNil(data["appVersion"])
        XCTAssertNotNil(data["sdkVersion"])
    }
}

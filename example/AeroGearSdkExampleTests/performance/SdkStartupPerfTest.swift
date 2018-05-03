
@testable import AGSCore
import Foundation
import XCTest

class SdkStartupPerfTest: XCTestCase {

    func testCoreStartupPresent() {
        self.measure {
            let core = AgsCore()
            _ = core.getConfiguration("keycloak")
        }
    }
}

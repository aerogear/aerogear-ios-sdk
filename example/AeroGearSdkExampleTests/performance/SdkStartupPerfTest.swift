
@testable import AGSCore
import Foundation
import XCTest

class SdkStartupPerfTest: XCTestCase {
    
    func testCoreStartupPresent() {
        self.measure {
            let core = AgsCore();
            let _ = core.getConfiguration("keycloak");
        }
    }
}


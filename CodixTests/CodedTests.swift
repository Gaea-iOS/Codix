//
// Copyright (c) 2021 Jerry Wang <4452242970@qq.com>
//

@testable import Codix
import XCTest

class CodedTests: XCTestCase {
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testCoded() {
        struct User: Decodixable {
            @Decoded(isRequired: true)
            var id: Int = 0

            @Decoded()
            var name: String = "Jerry"
        }
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }
}

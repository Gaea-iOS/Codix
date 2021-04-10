//
// Copyright (c) 2021 Jerry Wang <4452242970@qq.com>
//

@testable import Codix
import XCTest

class PathTests: XCTestCase {
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testValidPathPart() {
        let path = Path("abc[1]efg")
        XCTAssertEqual(path.components.count, 3)
        XCTAssertEqual(path.components[0], .key(.string("abc")))
        XCTAssertEqual(path.components[1], .index(1))
        XCTAssertEqual(path.components[2], .key(.string("efg")))
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }
}

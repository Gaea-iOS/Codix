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

    func testPathInitFromString() {
        let path = Path("response.[0]key1.key2[1]key3..key4")
        XCTAssertEqual(path.components.count, 7)
        XCTAssertEqual(path.components[0], "response")
        XCTAssertEqual(path.components[1], 0)
        XCTAssertEqual(path.components[2], "key1")
        XCTAssertEqual(path.components[3], "key2")
        XCTAssertEqual(path.components[4], 1)
        XCTAssertEqual(path.components[5], "key3")
        XCTAssertEqual(path.components[6], "key4")
    }

    func testPathInitFromArray() {
        let path: Path = ["key1", 0, "key2"]
        XCTAssertEqual(path.components.count, 3)
        XCTAssertEqual(path.components[0], "key1")
        XCTAssertEqual(path.components[1], 0)
        XCTAssertEqual(path.components[2], "key2")
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }
}

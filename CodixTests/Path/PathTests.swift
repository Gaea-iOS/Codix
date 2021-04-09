//
//  PathTests.swift
//  CodixTests
//
//  Created by Jerrywang on 2021/4/9.
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

    func testValidPathPart() throws {
        _ = try Path("[ddd][1]response[0]abc[1]haha")
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }
}

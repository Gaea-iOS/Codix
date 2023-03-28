// TransparentTransformerTests.swift
// Copyright (c) 2023 Nostudio
// Created by Jerry X T Wang on 2023/3/15.

@testable import Codix
import XCTest

class TransparentTransformerTests: XCTestCase {
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testTransparentTransformer() throws {
        let transformer1 = TransparentTransformer<String>()
        let value1 = try transformer1.transform("56")
        XCTAssertEqual(value1, "56")

        let transformer2 = TransparentTransformer<Int>()
        let value2 = try transformer2.transform(135)
        XCTAssertEqual(value2, 135)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }
}

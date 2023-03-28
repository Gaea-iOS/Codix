// DigitalTransformerTests.swift
// Copyright (c) 2023 Nostudio
// Created by Jerry X T Wang on 2023/3/15.

@testable import Codix
import XCTest

class DigitalTransformerTests: XCTestCase {
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testIntFromString() throws {
        let transformer = IntFromString()
        let value = try transformer.transform("56")
        XCTAssertEqual(value, 56)

        XCTAssertThrowsError(try transformer.transform("a87"))
    }

    func testDoubleFromString() throws {
        let transformer = DoubleFromString()
        let value1 = try transformer.transform("56")
        XCTAssertEqual(value1, 56)
        let value2 = try transformer.transform("56.834")
        XCTAssertEqual(value2, 56.834)

        XCTAssertThrowsError(try transformer.transform("a87"))
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }
}

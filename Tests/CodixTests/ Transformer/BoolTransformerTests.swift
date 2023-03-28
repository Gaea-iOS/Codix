// BoolTransformerTests.swift
// Copyright (c) 2023 Nostudio
// Created by Jerry X T Wang on 2023/3/14.

@testable import Codix
import XCTest

class BoolTransformerTests: XCTestCase {
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testBoolFromInt() throws {
        let transformer = BoolFromInt()
        let bool1 = try transformer.transform(1)
        let bool2 = try transformer.transform(2)
        let bool3 = try transformer.transform(105)
        let bool4 = try transformer.transform(0)
        let bool5 = try transformer.transform(-1)
        let bool6 = try transformer.transform(-290)

        XCTAssertTrue(bool1)
        XCTAssertTrue(bool2)
        XCTAssertTrue(bool3)
        XCTAssertFalse(bool4)
        XCTAssertTrue(bool5)
        XCTAssertTrue(bool6)
    }

    func testBoolFromString() throws {
        let transformer = BoolFromString(
            map: ["true": true, "True": true, "TRUE": true, "false": false, "False": false, "FALSE": false]
        )
        let bool1 = try transformer.transform("true")
        let bool2 = try transformer.transform("false")
        let bool3 = try transformer.transform("True")
        let bool4 = try transformer.transform("False")
        let bool5 = try transformer.transform("TRUE")
        let bool6 = try transformer.transform("FALSE")

        XCTAssertTrue(bool1)
        XCTAssertTrue(bool3)
        XCTAssertTrue(bool5)
        XCTAssertFalse(bool2)
        XCTAssertFalse(bool4)
        XCTAssertFalse(bool6)

        XCTAssertThrowsError(try transformer.transform("TRue"))
        XCTAssertThrowsError(try transformer.transform("FalSE"))
        XCTAssertThrowsError(try transformer.transform("F"))
        XCTAssertThrowsError(try transformer.transform("T"))
        XCTAssertThrowsError(try transformer.transform(""))
        XCTAssertThrowsError(try transformer.transform("dada"))
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }
}

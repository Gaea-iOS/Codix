// DateTransformerTests.swift
// Copyright (c) 2023 Nostudio
// Created by Jerry X T Wang on 2023/3/14.

@testable import Codix
import XCTest

class DateTransformerTests: XCTestCase {
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testDateFromString() throws {
        let transformer = DateFromString(format: "yyyy-MM-dd")
        let date = try transformer.transform("2014-09-13")
        let components = Calendar.current.dateComponents([.year, .month, .day], from: date)
        XCTAssertEqual(components.year, 2014)
        XCTAssertEqual(components.month, 9)
        XCTAssertEqual(components.day, 13)
    }

    func testDateFromTimeIntervalSince1970() throws {
        let transformer = DateFromTimeIntervalSince1970(unit: .second)
        let date = Calendar.current.date(from: DateComponents(year: 2020, month: 5, day: 17))!
        let transformedDate = try transformer.transform(date.timeIntervalSince1970)
        let components = Calendar.current.dateComponents([.year, .month, .day], from: transformedDate)
        XCTAssertEqual(components.year, 2020)
        XCTAssertEqual(components.month, 5)
        XCTAssertEqual(components.day, 17)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }
}

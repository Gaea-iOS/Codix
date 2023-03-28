// EncodedTests.swift
// Copyright (c) 2023 Nostudio
// Created by Jerry X T Wang on 2023/3/20.

@testable import Codix
import XCTest

class EncodedTests: XCTestCase {
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testEncoded() throws {
//        let json = """
//        {
//            "id": 1234,
//            "name": "Jerry",
//            "weibo": "http://www.weibo.com/jerry",
//            "pets": [
//                {
//                    "cat": {
//                        "id": 231,
//                        "name": "Tom"
//                    }
//                }
//            ]
//        }
//        """.data(using: .utf8)!

        struct User: Encodixable, Decodixable, Equatable {
            @Coded(isRequired: true)
            var id: Int = 0

            @Coded()
            var name: String = "Default"

            var weibo: URL?

            @Coded(isRequired: false)
            var age: Int = 16

            @Coded(path: "pets[0].cat.name")
            var catName: String? = nil
        }

        let user = User(id: 178, name: "Jerry", weibo: URL(string: "https://www.weibo.com")!, age: 12, catName: "Tom")
        let data = try JSONEncoder().encode(user)

        let decoder = JSONDecoder()
        let user2 = try decoder.decode(User.self, from: data)

        XCTAssertEqual(user2.id, 178)
        XCTAssertEqual(user2.name, "Jerry")
        XCTAssertNil(user2.weibo)
        XCTAssertEqual(user2.age, 12)
        XCTAssertEqual(user.catName, "Tom")
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }
}

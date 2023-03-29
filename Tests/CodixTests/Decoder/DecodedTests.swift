// DecodedTests.swift
// Copyright (c) 2023 Nostudio
// Created by Jerry X T Wang on 2023/3/7.

@testable import Codix
import XCTest

class DecodedTests: XCTestCase {
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testDecoded() throws {
        let json = """
        {
            "id": 1234,
            "name": "Jerry",
            "weibo": "http://www.weibo.com/jerry",
            "pets": [
                {
                    "cat": {
                        "id": 231,
                        "name": "Tom"
                    }
                }
            ]
        }
        """.data(using: .utf8)!

        struct User: Decodixable {
            @Decoded(isRequired: true)
            var id: Int = 0

            @Decoded()
            var name: String = "Default"

            var weibo: URL?
            
            @Decoded(isRequired: false)
            var age: Int = 16

            @Decoded(path: "pets[0].cat.name")
            var catName: String? = nil
        }

        let decoder = JSONDecoder()
        let user = try decoder.decode(User.self, from: json)

        XCTAssertEqual(user.id, 1234)
        XCTAssertEqual(user.name, "Jerry")
        XCTAssertNil(user.weibo)
        XCTAssertEqual(user.age, 16)
        XCTAssertEqual(user.catName, "Tom")
    }
    
    func testDecoded2() throws {
        let json = """
        {
            "id": 1234,
            "name": "Jerry",
            "weibo": "http://www.weibo.com/jerry",
            "pets": [
                {
                    "cat": {
                        "id": 231,
                        "name": "Tom"
                    }
                }
            ]
        }
        """.data(using: .utf8)!
        
        let json2 = """
        {
            "id": 1234,
            "name": "Jerry",
            "weibo": "http://www.weibo.com/jerry"
        }
        """.data(using: .utf8)!
        
        let json3 = """
        {
        }
        """.data(using: .utf8)!


        
        struct Cat: Decodixable, Equatable {
            @Decoded
            var id: Int = 0
            
            @Decoded(path: "name")
            var name: String = "Unknow"
        }

        struct User: Decodixable, Equatable {
            @Decoded()
            var id: Int = 0

            @Decoded()
            var name: String = "Default"

            var weibo: URL?
            
            @Decoded(isRequired: false)
            var age: Int = 16

            @Decoded(path: "pets[0].cat")
            var cat: Cat = Cat(id: 11, name: "ketty")
        }

        let decoder = JSONDecoder()
        let user = try decoder.decode(User.self, from: json)

        XCTAssertEqual(user.id, 1234)
        XCTAssertEqual(user.name, "Jerry")
        XCTAssertNil(user.weibo)
        XCTAssertEqual(user.age, 16)
        XCTAssertEqual(user.cat.id, 231)
        XCTAssertEqual(user.cat.name, "Tom")
        
        let user2 = try decoder.decode(User.self, from: json2)

        XCTAssertEqual(user2.id, 1234)
        XCTAssertEqual(user2.name, "Jerry")
        XCTAssertNil(user2.weibo)
        XCTAssertEqual(user2.age, 16)
        XCTAssertEqual(user2.cat.id, 11)
        XCTAssertEqual(user2.cat.name, "ketty")
        
        let user3 = try decoder.decode(User.self, from: json3)
        XCTAssertEqual(user3, User())
    }


    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }
}

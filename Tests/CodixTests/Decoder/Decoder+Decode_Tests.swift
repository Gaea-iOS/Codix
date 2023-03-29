// Decoder+Decode_Tests.swift
// Copyright (c) 2023 Nostudio
// Created by Jerry X T Wang on 2023/3/7.

@testable import Codix
import XCTest

class DecoderDecodeTests: XCTestCase {
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code wshere. This method is called after the invocation of each test method in the class.
    }

    func testDecodeAt() throws {
        let json = """
        {
            "id": 1234,
            "name": "Jerry",
            "weibo": "http://www.weibo.com/jerry",
        }
        """.data(using: .utf8)!

        struct User: Decodable {
            let userID: Int
            let nickName: String
            let weiboURL: URL

            init(from decoder: Decoder) throws {
                userID = try decoder.decode(at: "id")
                nickName = try decoder.decode(at: "name")
                weiboURL = try decoder.decode(at: "weibo")
            }
        }

        let user = try JSONDecoder().decode(User.self, from: json)
        XCTAssertEqual(user.userID, 1234)
        XCTAssertEqual(user.nickName, "Jerry")
        XCTAssertEqual(user.weiboURL.absoluteString, "http://www.weibo.com/jerry")
    }
    

    func testDecodeKeyedContainer() throws {
        let json = """
        {
            "zoo": {
                "id": 123233,
                "name": "West's Zoo"
            },
            "cats": [
                { "id": 2313, "name": "Tom" },
                { "id": 2314, "name": "Simon" }
            ],
            "addtionalInfo": {
                "detail": {
                    "desc": "Happy Zoo"
                }
            },
            "links": [
                { "name": "home page", "url": "http://www.zoo.com" }
            ]
        }
        """.data(using: .utf8)!

        struct Zoo: Decodable {
            let zooID: Int
            let name: String
            let cat: Cat

            let desc: String
            let link: URL

            init(from decoder: Decoder) throws {
                zooID = try decoder.decode(at: "zoo.id")
                name = try decoder.decode(at: "zoo.name")
                cat = try decoder.decode(at: "cats[0]")
                desc = try decoder.decode(at: "addtionalInfo.detail.desc")
                link = try decoder.decode(at: "links[0].url")
            }
        }

        struct Cat: Decodable, Equatable {
            let id: Int
            let name: String
        }

        let zoo = try JSONDecoder().decode(Zoo.self, from: json)
        XCTAssertEqual(zoo.zooID, 123_233)
        XCTAssertEqual(zoo.name, "West's Zoo")
        XCTAssertEqual(zoo.cat, Cat(id: 2313, name: "Tom"))
        XCTAssertEqual(zoo.desc, "Happy Zoo")
        XCTAssertEqual(zoo.link, URL(string: "http://www.zoo.com"))
    }

    func testDecodeUnkeyedContainer1() throws {
        let json = """
        [
            {
                "cat": { "id": 10, "name": "Tom" }
            }
        ]
        """.data(using: .utf8)!

        struct Zoo: Decodable {
            let cat: Cat

            init(from decoder: Decoder) throws {
                cat = try decoder.decode(at: "[0].cat")
            }
        }

        struct Cat: Decodable, Equatable {
            let id: Int
            let name: String
        }

        let zoo = try JSONDecoder().decode(Zoo.self, from: json)
        XCTAssertEqual(zoo.cat, Cat(id: 10, name: "Tom"))
    }

    func testDecodeUnkeyedContainer2() throws {
        let json = """
        [
            [
                { "id": 20, "name": "Tom" },
                { "id": 30, "name": "John" }
            ]
        ]
        """.data(using: .utf8)!

        struct Zoo: Decodable {
            let cat: Cat
            let catMaynotExist: Cat?

            init(from decoder: Decoder) throws {
                cat = try decoder.decode(at: "[0][1]")
                catMaynotExist = try? decoder.decode(at: "[0][2]")
            }
        }

        struct Cat: Decodable, Equatable {
            let id: Int
            let name: String
        }

        let zoo = try JSONDecoder().decode(Zoo.self, from: json)
        XCTAssertEqual(zoo.cat, Cat(id: 30, name: "John"))
        XCTAssertEqual(zoo.catMaynotExist, nil)
    }
    
    func test() throws {
        let json = """
        {
          "response": {
            "users": {
              "my_id": 78893,
              "nick_name": "Jerry",
              "profile": {
                "birth_day": "2000/08/12",
                "avatar": "https://images.baidu.com/avatars/27883.jpg",
                "role": "student"
              }
              "salary": "usd:4500",
              "male": "true"
            }
          }
        }
        """.data(using: .utf8)!

        enum Role: String, Decodable {
          case student
          case teacher
          case parent
        }

        enum Salary {
          case usd(Int)
          case rmb(Int)
        }

        struct SalaryTransformer: Transformer {
          func transform(_ value: String) throws -> Salary {
            let components = value.split(separator: ":")
            guard components.count == 2,
            components[0] == "usd" || components[0] == "rmb",
            let amount = Int(components[1]) else {
              throw CodixError.transformFailed("Can not transform \(value) to Enum Salary")
            }
            
            if components[0] == "usd" {
              return .usd(amount)
            } else {
              return .rmb(amount)
            }
          }
        }

        struct User: Decodable {
          let id: Int
          let name: String
          let birthdate: Date?
          let avatar: URL?
          let role: Role
          let salary: Salary
          let isMale: Bool
          
          init(from decoder: Decoder) throws {
            id = try decoder.decode(at: "my_id")
            name = try decoder.decode(at: "nick_name")
            birthdate = try decoder.decodeIfPresent(at: "profile.birth_day", using: DateFromString(format: "yyyy/MM/dd"))
            avatar = try decoder.decodeIfPresent(at: "profile.avatar")
            role = try decoder.decode(at: "role")
            salary = try decoder.decode(at: "salary", using: SalaryTransformer())
            isMale = try decoder.decode(at: "male", using: { $0 == "true" ? true : false })
          }
        }

        let user = try JSONDecoder().decode(User.self, from: json, at: "response.users[0]")
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }
}

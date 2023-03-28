// Encoder+Encode_Tests.swift
// Copyright (c) 2023 Nostudio
// Created by Jerry X T Wang on 2023/3/15.

@testable import Codix
import XCTest

class EncoderEncodeTests: XCTestCase {
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code wshere. This method is called after the invocation of each test method in the class.
    }

    func testEncodeAt() throws {
        struct User: Encodable, Decodable, Equatable {
            let userID: Int
            let nickName: String
            let weiboURL: URL

            init(userID: Int,
                 nickName: String,
                 weiboURL: URL)
            {
                self.userID = userID
                self.nickName = nickName
                self.weiboURL = weiboURL
            }

            init(from decoder: Decoder) throws {
                userID = try decoder.decode(at: "id")
                nickName = try decoder.decode(at: "name")
                weiboURL = try decoder.decode(at: "weibo")
            }

            func encode(to encoder: Encoder) throws {
                try encoder.encode(userID, at: "id")
                try encoder.encode(nickName, at: "name")
                try encoder.encode(weiboURL, at: "weibo")
            }
        }

        let user = User(userID: 1234, nickName: "Jerry", weiboURL: URL(string: "http://www.weibo.com/jerry")!)
        let data = try JSONEncoder().encode(user)

        let userDecoded = try JSONDecoder().decode(User.self, from: data)

        XCTAssertEqual(user, userDecoded)
    }

    func testEncodeKeyedContainer() throws {
        struct Zoo: Encodable, Decodable, Equatable {
            let zooID: Int
            let name: String
            let cat: Cat

            let desc: String
            let link: URL

            init(zooID: Int,
                 name: String,
                 cat: Cat,
                 desc: String,
                 link: URL)
            {
                self.zooID = zooID
                self.name = name
                self.cat = cat
                self.desc = desc
                self.link = link
            }

            init(from decoder: Decoder) throws {
                zooID = try decoder.decode(at: "zoo.id")
                name = try decoder.decode(at: "zoo.name")
                cat = try decoder.decode(at: "cats[1]")
                desc = try decoder.decode(at: "addtionalInfo.detail.desc")
                link = try decoder.decode(at: "links[0].url")
            }

            func encode(to encoder: Encoder) throws {
                try encoder.encode(zooID, at: "zoo.id")
                try encoder.encode(name, at: "zoo.name")
                try encoder.encode(cat, at: "cats[1]")
                try encoder.encode(desc, at: "addtionalInfo.detail.desc")
                try encoder.encode(link, at: "links[0].url")
            }
        }

        struct Cat: Encodable, Decodable, Equatable {
            let id: Int
            let name: String
        }

        let cat = Cat(id: 1653, name: "Tom")
        let zoo = Zoo(zooID: 873,
                      name: "West's Zoo",
                      cat: cat,
                      desc: "The biggest zoo in America",
                      link: URL(string: "http://www.zoo.com")!)

        let data = try JSONEncoder().encode(zoo)
        let zooDecoded = try JSONDecoder().decode(Zoo.self, from: data)

        XCTAssertEqual(zoo, zooDecoded)
    }

    func testEncodeUnkeyedContainer1() throws {
        struct Zoo: Encodable, Decodable, Equatable {
            let cat: Cat

            init(cat: Cat) {
                self.cat = cat
            }

            init(from decoder: Decoder) throws {
                cat = try decoder.decode(at: "[0].cat")
            }

            func encode(to encoder: Encoder) throws {
                try encoder.encode(cat, at: "[0].cat")
            }
        }

        struct Cat: Encodable, Decodable, Equatable {
            let id: Int
            let name: String
        }

        let cat = Cat(id: 1653, name: "Tom")
        let zoo = Zoo(cat: cat)

        let data = try JSONEncoder().encode(zoo)
        let zooDecoded = try JSONDecoder().decode(Zoo.self, from: data)

        XCTAssertEqual(zoo, zooDecoded)
    }

    func testEncodeUnkeyedContainer2() throws {
        struct Zoo: Encodable, Decodable, Equatable {
            let cat: Cat
            let catMaynotExist: Cat?

            init(cat: Cat, catMaynotExist: Cat?) {
                self.cat = cat
                self.catMaynotExist = catMaynotExist
            }

            init(from decoder: Decoder) throws {
                cat = try decoder.decode(at: "[0][1]")
                catMaynotExist = try? decoder.decode(at: "[0][2]")
            }

            func encode(to encoder: Encoder) throws {
                try encoder.encode(cat, at: "[0][1]")
                try encoder.encode(catMaynotExist, at: "[0][2]")
            }
        }

        struct Cat: Encodable, Decodable, Equatable {
            let id: Int
            let name: String
        }

        let cat = Cat(id: 1653, name: "Tom")
        let zoo = Zoo(cat: cat, catMaynotExist: nil)

        let data = try JSONEncoder().encode(zoo)
        let zooDecoded = try JSONDecoder().decode(Zoo.self, from: data)

        XCTAssertEqual(zoo, zooDecoded)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }
}

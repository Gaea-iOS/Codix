//
// Copyright (c) 2021 Jerry Wang <4452242970@qq.com>
//

import Foundation

extension UnkeyedDecodingContainer {
    mutating func decode<T>(_ type: T.Type = T.self, atIndex index: Int) throws -> T where T: Decodable {
        try move(to: index)
        return try decode(type)
    }

    mutating func decodeIfPresent<T>(_ type: T.Type = T.self, atIndex index: Int) throws -> T? where T: Decodable {
        try move(to: index)
        return try decodeIfPresent(type)
    }
}

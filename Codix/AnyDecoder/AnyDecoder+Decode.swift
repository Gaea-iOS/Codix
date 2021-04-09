//
//  AnyDecoder+Decode.swift
//  Codix
//
//  Created by Jerrywang on 2021/4/9.
//

import Foundation

extension CodingUserInfoKey {
    static let decodeRootKey = CodingUserInfoKey(rawValue: "decodeRootKey")!
}

public extension AnyDecoder {
    func decode<T>(_: T.Type = T.self,
                   from data: Data,
                   at path: Path) throws -> T
        where T: Decodable
    {
        userInfo[.decodeRootKey] = path
        let root = try decode(DecodableRoot<T>.self, from: data)
        return root.value
    }
}

public extension AnyDecoder {
    func decode<T, R>(_ type: T.Type = T.self,
                      from data: Data,
                      at path: Path,
                      using transformer: @escaping (R) throws -> T) throws -> T
        where R: Decodable
    {
        try decode(type, from: data, at: path, using: AnyTransformer(transformer))
    }
}

public extension AnyDecoder {
    func decode<T, F>(_: T.Type = T.self,
                      from data: Data,
                      at path: Path,
                      using transformer: F) throws -> T
        where F: Transformer, F.From: Decodable, F.To == T
    {
        let value = try decode(F.From.self, from: data, at: path)
        return try transformer.transform(value)
    }
}

struct DecodableRoot<T>: Decodable where T: Decodable {
    let value: T

    init(from decoder: Decoder) throws {
        guard let path = decoder.userInfo[.decodeRootKey] as? Path else {
            throw CodixError.valueNotFound("Can not find value at root level")
        }
        value = try decoder.decode(at: path)
    }
}

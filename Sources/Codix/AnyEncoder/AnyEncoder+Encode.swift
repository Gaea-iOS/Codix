// AnyEncoder+Encode.swift
// Copyright (c) 2023 Nostudio
// Created by Jerry X T Wang on 2023/3/7.

import Foundation

private extension CodingUserInfoKey {
    static let encodeRootPath = CodingUserInfoKey(rawValue: "encodeRootPath")!
}

public extension AnyEncoder {
    func encode(
        _ value: some Encodable,
        at path: Path
    ) throws -> Data {
        userInfo[.encodeRootPath] = path
        let root = EncodableRoot(value: value)
        return try encode(root)
    }
}

public extension AnyEncoder {
    func encode<T>(
        _ value: T,
        at path: Path,
        using transformer: @escaping (T) throws -> some Encodable
    ) throws -> Data {
        try encode(value, at: path, using: AnyTransformer(transformer))
    }
}

public extension AnyEncoder {
    func encode<T, F>(
        _ value: T,
        at path: Path,
        using transformer: F
    ) throws -> Data where F: Transformer, F.From == T, F.To: Encodable {
        let transformedValue = try transformer.transform(value)
        return try encode(transformedValue, at: path)
    }
}

struct EncodableRoot<T>: Encodable where T: Encodable {
    let value: T

    func encode(to encoder: Encoder) throws {
        guard let path = encoder.userInfo[.encodeRootPath] as? Path else {
            throw CodixError.valueNotFound("Can not find value at root level")
        }
        try encoder.encode(value, at: path)
    }
}

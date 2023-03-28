// Encoder+Encode.swift
// Copyright (c) 2023 Nostudio
// Created by Jerry X T Wang on 2023/3/7.

import Foundation

public extension Encoder {
    func encode(
        _ value: some Encodable,
        at path: Path
    ) throws {
        try _encode(value, at: path)
    }
}

public extension Encoder {
    func encode<T, F>(
        _ value: T,
        at path: Path,
        using transformer: F
    ) throws where F: Transformer, F.From == T, F.To: Encodable {
        let transformedValue = try transformer.transform(value)
        try _encode(transformedValue, at: path)
    }
}

public extension Encoder {
    func encode<T>(
        _ value: T,
        at path: Path,
        using transformer: @escaping (T) throws -> some Encodable
    ) throws {
        try encode(value, at: path, using: AnyTransformer(transformer))
    }
}

private extension Encoder {
    func _encode(
        _ value: some Encodable,
        at path: Path
    ) throws {
        guard let lastComponent = path.components.last else {
            let context = CodixError.Context(codingPath: codingPath, debugDescription: "Invalid path.")
            throw CodixError.invalidKey(context)
        }
        let findingPath = Path(Array(path.components.dropLast()))
        switch lastComponent {
        case let .key(key):
            var container = try nestedKeyedContainer(at: findingPath)
            return try container.encode(value, forKey: key)
        case let .index(index):
            var container = try nestedUnkeyedContainer(at: findingPath)
            return try container.encode(value, atIndex: index)
        }
    }
}

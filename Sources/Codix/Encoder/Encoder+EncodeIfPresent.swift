// Encoder+EncodeIfPresent.swift
// Copyright (c) 2023 Nostudio
// Created by Jerry X T Wang on 2023/3/7.

import Foundation

public extension Encoder {
    func encodeIfPresent(
        _ value: (some Encodable)?,
        at path: Path
    ) throws {
        try _encodeIfPresent(value, at: path)
    }
}

public extension Encoder {
    func encodeIfPresent<T, F>(
        _ value: T?,
        at path: Path,
        using transformer: F
    ) throws where F: Transformer, F.From == T, F.To: Encodable {
        let transformedValue = try value.flatMap(transformer.transform(_:))
        try _encodeIfPresent(transformedValue, at: path)
    }
}

public extension Encoder {
    func encodeIfPresent<T>(
        _ value: T?,
        at path: Path,
        using transformer: @escaping (T) throws -> some Encodable
    ) throws {
        try encodeIfPresent(value, at: path, using: AnyTransformer(transformer))
    }
}

private extension Encoder {
    func _encodeIfPresent(
        _ value: (some Encodable)?,
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
            return try container.encodeIfPresent(value, forKey: key)
        case let .index(index):
            var container = try nestedUnkeyedContainer(at: findingPath)
            return try container.encodeIfPresent(value, atIndex: index)
        }
    }
}

// Decoder+DecodeIfPresent.swift
// Copyright (c) 2023 Nostudio
// Created by Jerry X T Wang on 2023/3/7.

import Foundation

public extension Decoder {
    func decodeIfPresent<T>(
        _: T.Type = T.self,
        at path: Path
    ) throws -> T? where T: Decodable {
        try _decodeIfPresent(at: path)
    }
}

public extension Decoder {
    func decodeIfPresent<T, F>(
        _: T.Type = T.self,
        at path: Path,
        using transformer: F
    ) throws -> T? where F: Transformer, F.From: Decodable, F.To == T {
        let value = try _decodeIfPresent(F.From.self, at: path)
        return try value.flatMap(transformer.transform(_:))
    }
}

public extension Decoder {
    func decodeIfPresent<T, R>(
        _: T.Type = T.self,
        at path: Path,
        using transformer: @escaping (R) throws -> T
    ) throws -> T? where R: Decodable {
        try decodeIfPresent(at: path, using: AnyTransformer(transformer))
    }
}

private extension Decoder {
    func _decodeIfPresent<T>(
        _ type: T.Type = T.self,
        at path: Path
    ) throws -> T? where T: Decodable {
        guard let lastComponent = path.components.last else {
            let context = CodixError.Context(codingPath: codingPath, debugDescription: "Invalid path.")
            throw CodixError.invalidKey(context)
        }
        let findingPath = Path(Array(path.components.dropLast()))
        switch lastComponent {
        case let .key(key):
            let container = try nestedKeyedContainer(at: findingPath)
            return try container.decodeIfPresent(type, forKey: key)
        case let .index(index):
            var container = try nestedUnkeyedContainer(at: findingPath)
            return try container.decodeIfPresent(atIndex: index)
        }
    }
}

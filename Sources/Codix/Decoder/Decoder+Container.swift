// Decoder+Container.swift
// Copyright (c) 2023 Nostudio
// Created by Jerry X T Wang on 2023/3/7.

import Foundation

private extension Decoder {
    func keyedContainer() throws -> KeyedDecodingContainer<PathComponent.Key> {
        try container(keyedBy: PathComponent.Key.self)
    }
}

extension Decoder {
    func nestedKeyedContainer(
        at path: Path = []
    ) throws -> KeyedDecodingContainer<PathComponent.Key> {
        if path.components.count == 0 {
            return try keyedContainer()
        } else {
            let component = path.components[0]
            switch component {
            case .key:
                let container = try keyedContainer()
                return try container.nestedKeyedContainer(at: path)
            case .index:
                var container = try unkeyedContainer()
                return try container.nestedKeyedContainer(at: path)
            }
        }
    }

    func nestedUnkeyedContainer(
        at path: Path = []
    ) throws -> UnkeyedDecodingContainer {
        if path.components.count == 0 {
            return try unkeyedContainer()
        } else {
            let component = path.components[0]
            switch component {
            case .key:
                let container = try keyedContainer()
                return try container.nestedUnkeyedContainer(at: path)
            case .index:
                var container = try unkeyedContainer()
                return try container.nestedUnkeyedContainer(at: path)
            }
        }
    }
}

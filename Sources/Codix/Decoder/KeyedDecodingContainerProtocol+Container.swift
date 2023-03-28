// KeyedDecodingContainerProtocol+Container.swift
// Copyright (c) 2023 Nostudio
// Created by Jerry X T Wang on 2023/3/7.

import Foundation

private extension KeyedDecodingContainerProtocol where Key == PathComponent.Key {
    func nestedKeyedContainer(
        at key: Key
    ) throws -> KeyedDecodingContainer<Key> {
        try nestedContainer(keyedBy: Key.self, forKey: key)
    }

    func nestedUnkeyedContainer(at key: Key) throws
        -> UnkeyedDecodingContainer
    {
        try nestedUnkeyedContainer(forKey: key)
    }
}

private extension KeyedDecodingContainerProtocol where Key == PathComponent.Key {
    func nestedKeyedContainer(
        at component: PathComponent
    ) throws -> KeyedDecodingContainer<Key> {
        guard case let .key(key) = component else {
            let context = CodixError.Context(
                codingPath: codingPath,
                debugDescription: "Can not access index in KeyedDecodingContainer"
            )
            throw CodixError.invalidKey(context)
        }
        return try nestedKeyedContainer(at: key)
    }

    func nestedUnkeyedContainer(
        at component: PathComponent
    ) throws -> UnkeyedDecodingContainer {
        guard case let .key(key) = component else {
            let context = CodixError.Context(
                codingPath: codingPath,
                debugDescription: "Can not access index in KeyedDecodingContainer"
            )
            throw CodixError.invalidKey(context)
        }
        return try nestedUnkeyedContainer(at: key)
    }
}

extension KeyedDecodingContainerProtocol where Key == PathComponent.Key {
    func nestedKeyedContainer(
        at path: Path
    ) throws -> KeyedDecodingContainer<Key> {
        if path.components.count == 0 {
            let context = CodixError.Context(
                codingPath: codingPath,
                debugDescription: "Invalid path."
            )
            throw CodixError.invalidKey(context)
        } else if path.components.count == 1 {
            let component = path.components[0]
            return try nestedKeyedContainer(at: component)
        } else {
            let component = path.components[0]
            let nextComponent = path.components[1]
            let leftPath = Path(Array(path.components.dropFirst()))

            switch nextComponent {
            case .key:
                let container = try nestedKeyedContainer(at: component)
                return try container.nestedKeyedContainer(at: leftPath)
            case .index:
                var container = try nestedUnkeyedContainer(at: component)
                return try container.nestedKeyedContainer(at: leftPath)
            }
        }
    }

    func nestedUnkeyedContainer(
        at path: Path
    ) throws -> UnkeyedDecodingContainer {
        if path.components.count == 0 {
            let context = CodixError.Context(
                codingPath: [],
                debugDescription: "Empty path is not allowed."
            )
            throw CodixError.invalidKey(context)
        } else if path.components.count == 1 {
            let component = path.components[0]
            return try nestedUnkeyedContainer(at: component)
        } else {
            let component = path.components[0]
            let nextComponent = path.components[1]
            let leftPath = Path(Array(path.components.dropFirst()))

            switch nextComponent {
            case .key:
                let container = try nestedKeyedContainer(at: component)
                return try container.nestedUnkeyedContainer(at: leftPath)
            case .index:
                var container = try nestedUnkeyedContainer(at: component)
                return try container.nestedUnkeyedContainer(at: leftPath)
            }
        }
    }
}

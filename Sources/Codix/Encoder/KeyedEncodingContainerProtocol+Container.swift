// KeyedEncodingContainerProtocol+Container.swift
// Copyright (c) 2023 Nostudio
// Created by Jerry X T Wang on 2023/3/7.

import Foundation

private extension KeyedEncodingContainerProtocol where Key == PathComponent.Key {
    mutating func nestedKeyedContainer(
        at key: Key
    ) -> KeyedEncodingContainer<Key> {
        nestedContainer(keyedBy: Key.self, forKey: key)
    }

    mutating func nestedUnkeyedContainer(
        at key: Key
    ) -> UnkeyedEncodingContainer {
        nestedUnkeyedContainer(forKey: key)
    }
}

private extension KeyedEncodingContainerProtocol where Key == PathComponent.Key {
    mutating func nestedKeyedContainer(
        at component: PathComponent
    ) throws -> KeyedEncodingContainer<Key> {
        guard case let .key(key) = component else {
            let context = CodixError.Context(
                codingPath: codingPath,
                debugDescription: "Can not access index in KeyedDecodingContainer"
            )
            throw CodixError.invalidKey(context)
        }
        return nestedKeyedContainer(at: key)
    }

    mutating func nestedUnkeyedContainer(
        at component: PathComponent
    ) throws -> UnkeyedEncodingContainer {
        guard case let .key(key) = component else {
            let context = CodixError.Context(
                codingPath: codingPath,
                debugDescription: "Can not access index in KeyedDecodingContainer"
            )
            throw CodixError.invalidKey(context)
        }
        return nestedUnkeyedContainer(at: key)
    }
}

extension KeyedEncodingContainerProtocol where Key == PathComponent.Key {
    mutating func nestedKeyedContainer(
        at path: Path
    ) throws -> KeyedEncodingContainer<Key> {
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
                var container = try nestedKeyedContainer(at: component)
                return try container.nestedKeyedContainer(at: leftPath)
            case .index:
                var container = try nestedUnkeyedContainer(at: component)
                return try container.nestedKeyedContainer(at: leftPath)
            }
        }
    }

    mutating func nestedUnkeyedContainer(
        at path: Path
    ) throws -> UnkeyedEncodingContainer {
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
                var container = try nestedKeyedContainer(at: component)
                return try container.nestedUnkeyedContainer(at: leftPath)
            case .index:
                var container = try nestedUnkeyedContainer(at: component)
                return try container.nestedUnkeyedContainer(at: leftPath)
            }
        }
    }
}

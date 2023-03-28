// UnkeyedEncodingContainer+Container.swift
// Copyright (c) 2023 Nostudio
// Created by Jerry X T Wang on 2023/3/7.

import Foundation

private extension UnkeyedEncodingContainer {
    mutating func nestedKeyedContainer(
        at index: Int
    ) throws -> KeyedEncodingContainer<PathComponent.Key> {
        try move(to: index)
        return nestedContainer(keyedBy: PathComponent.Key.self)
    }

    mutating func nestedUnkeyedContainer(
        at index: Int
    ) throws -> UnkeyedEncodingContainer {
        try move(to: index)
        return nestedUnkeyedContainer()
    }
}

private extension UnkeyedEncodingContainer {
    mutating func nestedKeyedContainer(
        at component: PathComponent
    ) throws -> KeyedEncodingContainer<PathComponent.Key> {
        guard case let .index(index) = component else {
            let context = CodixError.Context(
                codingPath: codingPath,
                debugDescription: "Can not access key in UnkeyedDecodingContainer"
            )
            throw CodixError.invalidKey(context)
        }
        return try nestedKeyedContainer(at: index)
    }

    mutating func nestedUnkeyedContainer(
        at component: PathComponent
    ) throws -> UnkeyedEncodingContainer {
        guard case let .index(index) = component else {
            let context = CodixError.Context(
                codingPath: codingPath,
                debugDescription: "Can not access key in UnkeyedDecodingContainer"
            )
            throw CodixError.invalidKey(context)
        }
        return try nestedUnkeyedContainer(at: index)
    }
}

extension UnkeyedEncodingContainer {
    mutating func nestedKeyedContainer(
        at path: Path
    ) throws -> KeyedEncodingContainer<PathComponent.Key> {
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

//
//  File.swift
//  Codix
//
//  Created by Jerrywang on 2021/4/9.
//

import Foundation

private extension UnkeyedDecodingContainer {
    mutating func nestedContainer(at index: Int) throws -> KeyedDecodingContainer<PathComponent.Key> {
        try move(to: index)
        return try nestedContainer(keyedBy: PathComponent.Key.self)
    }

    mutating func nestedUnkeyedContainer(at index: Int) throws -> UnkeyedDecodingContainer {
        try move(to: index)
        return try nestedUnkeyedContainer()
    }
}

private extension UnkeyedDecodingContainer {
    mutating func nestedContainer(at component: PathComponent) throws -> KeyedDecodingContainer<PathComponent.Key> {
        guard case let .index(index) = component else {
            let context = CodixError.Context(codingPath: codingPath, debugDescription: "Can not access key in UnkeyedDecodingContainer")
            throw CodixError.invalidKey(context)
        }
        return try nestedContainer(at: index)
    }

    mutating func nestedUnkeyedContainer(at component: PathComponent) throws -> UnkeyedDecodingContainer {
        guard case let .index(index) = component else {
            let context = CodixError.Context(codingPath: codingPath, debugDescription: "Can not access key in UnkeyedDecodingContainer")
            throw CodixError.invalidKey(context)
        }
        return try nestedUnkeyedContainer(at: index)
    }
}

extension UnkeyedDecodingContainer {
    mutating func nestedContainer(at path: Path) throws -> KeyedDecodingContainer<PathComponent.Key> {
        if path.components.count == 0 {
            let context = CodixError.Context(codingPath: codingPath, debugDescription: "Invalid path.")
            throw CodixError.invalidKey(context)
        } else if path.components.count == 1 {
            let component = path.components[0]
            return try nestedContainer(at: component)
        } else {
            let component = path.components[0]
            let nextComponent = path.components[1]
            let leftPath = Path(Array(path.components.dropFirst()))

            switch nextComponent {
            case .key:
                let container = try nestedContainer(at: component)
                return try container.nestedContainer(at: leftPath)
            case .index:
                var container = try nestedUnkeyedContainer(at: component)
                return try container.nestedContainer(at: leftPath)
            }
        }
    }

    mutating func nestedUnkeyedContainer(at path: Path) throws -> UnkeyedDecodingContainer {
        if path.components.count == 0 {
            let context = CodixError.Context(codingPath: [], debugDescription: "Empty path is not allowed.")
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
                let container = try nestedContainer(at: component)
                return try container.nestedUnkeyedContainer(at: leftPath)
            case .index:
                var container = try nestedUnkeyedContainer(at: component)
                return try container.nestedUnkeyedContainer(at: leftPath)
            }
        }
    }
}

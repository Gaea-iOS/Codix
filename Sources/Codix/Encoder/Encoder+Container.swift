// Encoder+Container.swift
// Copyright (c) 2023 Nostudio
// Created by Jerry X T Wang on 2023/3/7.

import Foundation

private extension Encoder {
    func keyedContainer() -> KeyedEncodingContainer<PathComponent.Key> {
        container(keyedBy: PathComponent.Key.self)
    }
}

extension Encoder {
    func nestedKeyedContainer(
        at path: Path = []
    ) throws -> KeyedEncodingContainer<PathComponent.Key> {
        if path.components.count == 0 {
            return keyedContainer()
        } else {
            let component = path.components[0]
            switch component {
            case .key:
                var container = keyedContainer()
                return try container.nestedKeyedContainer(at: path)
            case .index:
                var container = unkeyedContainer()
                return try container.nestedKeyedContainer(at: path)
            }
        }
    }

    func nestedUnkeyedContainer(
        at path: Path = []
    ) throws -> UnkeyedEncodingContainer {
        if path.components.count == 0 {
            return unkeyedContainer()
        } else {
            let component = path.components[0]
            switch component {
            case .key:
                var container = keyedContainer()
                return try container.nestedUnkeyedContainer(at: path)
            case .index:
                var container = unkeyedContainer()
                return try container.nestedUnkeyedContainer(at: path)
            }
        }
    }
}

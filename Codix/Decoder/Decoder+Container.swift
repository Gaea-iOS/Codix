//
//  File.swift
//  Codix
//
//  Created by Jerrywang on 2021/4/9.
//

import Foundation

private extension Decoder {
    func container() throws -> KeyedDecodingContainer<PathComponent.Key> {
        try container(keyedBy: PathComponent.Key.self)
    }
}

extension Decoder {
    func nestedContainer(at path: Path = []) throws -> KeyedDecodingContainer<PathComponent.Key> {
        if path.components.count == 0 {
            return try container()
        } else {
            let component = path.components[0]
            switch component {
            case .key:
                let container = try self.container()
                return try container.nestedContainer(at: path)
            case .index:
                var container = try unkeyedContainer()
                return try container.nestedContainer(at: path)
            }
        }
    }

    func nestedUnkeyedContainer(at path: Path = []) throws -> UnkeyedDecodingContainer {
        if path.components.count == 0 {
            return try unkeyedContainer()
        } else {
            let component = path.components[0]
            switch component {
            case .key:
                let container = try self.container()
                return try container.nestedUnkeyedContainer(at: path)
            case .index:
                var container = try unkeyedContainer()
                return try container.nestedUnkeyedContainer(at: path)
            }
        }
    }
}

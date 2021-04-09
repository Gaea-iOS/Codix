//
//  UnkeyedDecodingContainer.swift
//  Codix
//
//  Created by Jerrywang on 2021/4/9.
//

import Foundation

private struct DummyCodable: Codable {}

extension UnkeyedDecodingContainer {
    mutating func moveNext() {
        _ = try? decode(DummyCodable.self)
    }

    mutating func move(to index: Int) throws {
        while currentIndex != index, !isAtEnd {
            moveNext()
        }

        if isAtEnd {
            let context = CodixError.Context(codingPath: codingPath, debugDescription: "Decode index \(index) out of range")
            throw CodixError.indexOutOfRange(context)
        }
    }
}

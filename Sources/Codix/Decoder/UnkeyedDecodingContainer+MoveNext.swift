// UnkeyedDecodingContainer+MoveNext.swift
// Copyright (c) 2023 Nostudio
// Created by Jerry X T Wang on 2023/3/7.

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
            let context = CodixError.Context(
                codingPath: codingPath,
                debugDescription: "Decode index \(index) out of range"
            )
            throw CodixError.indexOutOfRange(context)
        }
    }
}

// UnkeyedEncodingContainer+MoveNext.swift
// Copyright (c) 2023 Nostudio
// Created by Jerry X T Wang on 2023/3/7.

import Foundation

private struct DummyCodable: Codable {}

extension UnkeyedEncodingContainer {
    mutating func moveNext() throws {
        try encodeNil()
    }

    mutating func move(to index: Int) throws {
        while count < index {
            try moveNext()
        }
    }
}

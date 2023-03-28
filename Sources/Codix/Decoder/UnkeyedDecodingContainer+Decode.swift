// UnkeyedDecodingContainer+Decode.swift
// Copyright (c) 2023 Nostudio
// Created by Jerry X T Wang on 2023/3/7.

import Foundation

extension UnkeyedDecodingContainer {
    mutating func decode<T>(
        _ type: T.Type = T.self,
        atIndex index: Int
    ) throws -> T where T: Decodable {
        try move(to: index)
        return try decode(type)
    }

    mutating func decodeIfPresent<T>(
        _ type: T.Type = T.self,
        atIndex index: Int
    ) throws -> T? where T: Decodable {
        try move(to: index)
        return try decodeIfPresent(type)
    }
}

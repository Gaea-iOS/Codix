// UnkeyedEncodingContainer+Decode.swift
// Copyright (c) 2023 Nostudio
// Created by Jerry X T Wang on 2023/3/7.

import Foundation

extension UnkeyedEncodingContainer {
    mutating func encode(
        _ value: some Encodable,
        atIndex index: Int
    ) throws {
        try move(to: index)
        try encode(value)
    }

    mutating func encodeIfPresent(
        _ value: (some Encodable)?,
        atIndex index: Int
    ) throws {
        try move(to: index)
        if let value {
            try encode(value)
        } else {
            try encodeNil()
        }
    }
}

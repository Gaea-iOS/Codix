// Encodixable.swift
// Copyright (c) 2023 Nostudio
// Created by Jerry X T Wang on 2023/3/13.

import Foundation

protocol PropertyWrapperEncoding {
    mutating func encode(to encoder: Encoder, forLabel label: String) throws
}

protocol Encodixable: Encodable {}

extension Encodixable {
    func encode(to encoder: Encoder) throws {
        for child in Mirror(reflecting: self).children {
            guard var decodingValue = child.value as? PropertyWrapperEncoding,
                  let label = child.label
            else {
                continue
            }
            try decodingValue.encode(to: encoder, forLabel: label)
        }
    }
}

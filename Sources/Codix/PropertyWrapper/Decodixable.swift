// Decodixable.swift
// Copyright (c) 2023 Nostudio
// Created by Jerry X T Wang on 2023/3/7.

import Foundation

protocol PropertyWrapperDecoding {
    mutating func decode(from decoder: Decoder, forLabel label: String) throws
}

public protocol Initializable {
    init()
}

public protocol Decodixable: Decodable & Initializable {}

extension Decodixable {
    public init(from decoder: Decoder) throws {
        self.init()

        for child in Mirror(reflecting: self).children {
            guard var decodingValue = child.value as? PropertyWrapperDecoding,
                  let label = child.label
            else {
                continue
            }
            try decodingValue.decode(from: decoder, forLabel: label)
        }
    }
}

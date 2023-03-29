// Encodixable.swift
// Copyright (c) 2023 Nostudio
// Created by Jerry X T Wang on 2023/3/13.

import Foundation

protocol PropertyWrapperEncoding {
    func encode(to encoder: Encoder, forLabel label: String) throws
}

public protocol Encodixable: Encodable {}

extension Encodixable {
    public func encode(to encoder: Encoder) throws {
        for child in Mirror(reflecting: self).children {
            if var decodingValue = child.value as? PropertyWrapperEncoding,
               let label = child.label {
                try decodingValue.encode(to: encoder, forLabel: label)
            }
        }
    }
}

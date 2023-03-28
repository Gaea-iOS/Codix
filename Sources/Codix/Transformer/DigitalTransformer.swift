// DigitalTransformer.swift
// Copyright (c) 2023 Nostudio
// Created by Jerry X T Wang on 2023/3/7.

import Foundation

public struct IntFromString: Transformer {
    public func transform(_ value: String) throws -> Int {
        guard let decimal = Int(value) else {
            throw CodixError.transformFailed("Can not transform Int from String \(value)")
        }
        return decimal
    }
}

public struct DoubleFromString: Transformer {
    public func transform(_ value: String) throws -> Double {
        guard let decimal = Double(value) else {
            throw CodixError.transformFailed("Can not transform Double from String \(value)")
        }
        return decimal
    }
}

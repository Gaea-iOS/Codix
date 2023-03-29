// Dedoded.swift
// Copyright (c) 2023 Nostudio
// Created by Jerry X T Wang on 2023/3/7.

import Foundation

@propertyWrapper
public final class Decoded<Value, Trans> where Trans: Transformer, Trans.To == Value {
    /** the decode path */
    private let path: Path?

    /** Indicate whether path must present or not. */
    private let isRequired: Bool

    /** The data transformer */
    private let transformer: Trans

    public var wrappedValue: Value

    public init(wrappedValue: Value,
                path: Path? = nil,
                isRequired: Bool = false,
                using transformer: Trans)
    {
        self.wrappedValue = wrappedValue
        self.path = path
        self.isRequired = isRequired
        self.transformer = transformer
    }

    public init(wrappedValue: Value,
                path: Path? = nil,
                isRequired: Bool = false,
                using transformer: Trans = .init())
        where Trans == TransparentTransformer<Value>
    {
        self.wrappedValue = wrappedValue
        self.path = path
        self.isRequired = isRequired
        self.transformer = transformer
    }
}

extension Decoded: PropertyWrapperDecoding where Trans.From: Decodable {
    func decode(from decoder: Decoder, forLabel label: String) throws {
        /*
         Compiler will auto generate a internal property named "_{property_name}" for the property wrapped by property wrapper.
         Refer to Language Guide/Properties of book <The Swift Programming Language (Swift 5.2)>
         */
        let path = path ?? Path(label.removingPrefix("_"))
        if isRequired {
            wrappedValue = try decoder.decode(at: path, using: transformer)
        } else {
            if let value = try decoder.decodeIfPresent(at: path, using: transformer) {
                wrappedValue = value
            }
        }
    }
}

extension Decoded: Equatable where Value: Equatable {
    public static func == (lhs: Decoded<Value, Trans>, rhs: Decoded<Value, Trans>) -> Bool {
        lhs.wrappedValue == rhs.wrappedValue
    }
}

extension String {
    func removingPrefix(_ prefix: String) -> String {
        guard hasPrefix(prefix) else {
            return self
        }
        return String(dropFirst(prefix.count))
    }
}



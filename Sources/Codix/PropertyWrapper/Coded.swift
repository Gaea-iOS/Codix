// Coded.swift
// Copyright (c) 2023 Nostudio
// Created by Jerry X T Wang on 2023/3/13.

import Foundation

@propertyWrapper
public struct Coded<Value, Forwoard, Backward>
    where Forwoard: Transformer,
    Backward: Transformer,
    Forwoard.From == Value,
    Forwoard.To: Encodable,
    Backward.To == Value,
    Backward.From: Decodable
{
    /** the decode path */
    private let path: Path?

    /** Indicate whether path must present or not. */
    private let isRequired: Bool

    /** The data transformer */
    private let forward: Forwoard

    private let backward: Backward

    public var wrappedValue: Value

    public init(wrappedValue: Value,
                path: Path? = nil,
                isRequired: Bool = false,
                forward: Forwoard,
                backward: Backward)
    {
        self.wrappedValue = wrappedValue
        self.path = path
        self.isRequired = isRequired
        self.forward = forward
        self.backward = backward
    }

    public init(wrappedValue: Value,
                path: Path? = nil,
                isRequired: Bool = false,
                forword: Forwoard = .init(),
                backward: Backward = .init())
        where Forwoard == TransparentTransformer<Value>, Backward == TransparentTransformer<Value>
    {
        self.wrappedValue = wrappedValue
        self.path = path
        self.isRequired = isRequired
        forward = forword
        self.backward = backward
    }
}

extension Coded: PropertyWrapperEncoding where Forwoard.To: Encodable {
    func encode(to encoder: Encoder, forLabel label: String) throws {
        /*
         Compiler will auto generate a internal property named "_{property_name}" for the property wrapped by property wrapper.
         Refer to Language Guide/Properties of book <The Swift Programming Language (Swift 5.2)>
         */
        let path = path ?? Path(label.removingPrefix("_"))
        if isRequired {
            try encoder.encode(wrappedValue, at: path, using: forward)
        } else {
            try encoder.encodeIfPresent(wrappedValue, at: path, using: forward)
        }
    }
}

extension Coded: PropertyWrapperDecoding where Backward.From: Decodable {
    mutating func decode(from decoder: Decoder, forLabel label: String) throws {
        /*
         Compiler will auto generate a internal property named "_{property_name}" for the property wrapped by property wrapper.
         Refer to Language Guide/Properties of book <The Swift Programming Language (Swift 5.2)>
         */
        let path = path ?? Path(label.removingPrefix("_"))
        if isRequired {
            wrappedValue = try decoder.decode(at: path, using: backward)
        } else {
            if let value = try decoder.decodeIfPresent(at: path, using: backward) {
                wrappedValue = value
            }
        }
    }
}

extension Coded: Equatable where Value: Equatable {
    public static func == (lhs: Coded<Value, Forwoard, Backward>, rhs: Coded<Value, Forwoard, Backward>) -> Bool {
        lhs.wrappedValue == rhs.wrappedValue
    }
}


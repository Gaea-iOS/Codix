// Encoded.swift
// Copyright (c) 2023 Nostudio
// Created by Jerry X T Wang on 2023/3/13.

import Foundation

@propertyWrapper
public struct Encoded<Value, Trans> where Trans: Transformer, Trans.From == Value {
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
                using transformer: Trans = TransparentTransformer<Value>())
        where Trans == TransparentTransformer<Value>
    {
        self.wrappedValue = wrappedValue
        self.path = path
        self.isRequired = isRequired
        self.transformer = transformer
    }
}

extension Encoded: PropertyWrapperEncoding where Trans.To: Encodable {
    func encode(to encoder: Encoder, forLabel label: String) throws {
        /*
         Compiler will auto generate a internal property named "_{property_name}" for the property wrapped by property wrapper.
         Refer to Language Guide/Properties of book <The Swift Programming Language (Swift 5.2)>
         */
        let path = path ?? Path(label.removingPrefix("_"))
        if isRequired {
            try encoder.encode(wrappedValue, at: path, using: transformer)
        } else {
            try encoder.encodeIfPresent(wrappedValue, at: path, using: transformer)
        }
    }
}

// TransparentTransformer.swift
// Copyright (c) 2023 Nostudio
// Created by Jerry X T Wang on 2023/3/7.

import Foundation

public struct TransparentTransformer<Value>: Transformer {
    public init() {}
    public func transform(_ value: Value) throws -> Value {
        value
    }
}

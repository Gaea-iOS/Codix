// TransparentTransformer.swift
// Copyright (c) 2023 Nostudio
// Created by Jerry X T Wang on 2023/3/7.

import Foundation

struct TransparentTransformer<Value>: Transformer {
    func transform(_ value: Value) throws -> Value {
        value
    }
}

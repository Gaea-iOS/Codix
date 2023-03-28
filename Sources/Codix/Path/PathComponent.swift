// PathComponent.swift
// Copyright (c) 2023 Nostudio
// Created by Jerry X T Wang on 2023/3/7.

import Foundation

public enum PathComponent {
    public enum Key {
        case string(String)
        case int(Int)
    }

    case key(Key)
    case index(Int)
}

extension PathComponent: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self = .key(.string(value))
    }
}

extension PathComponent: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: IntegerLiteralType) {
        self = .index(value)
    }
}

extension PathComponent: Equatable {}

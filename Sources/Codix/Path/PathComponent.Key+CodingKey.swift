// PathComponent.Key+CodingKey.swift
// Copyright (c) 2023 Nostudio
// Created by Jerry X T Wang on 2023/3/7.

import Foundation

extension PathComponent.Key: CodingKey {
    public var stringValue: String {
        switch self {
        case let .string(key):
            return key
        case let .int(key):
            return "Index \(key)"
        }
    }

    public var intValue: Int? {
        switch self {
        case .string:
            return nil
        case let .int(key):
            return key
        }
    }

    public init?(stringValue: String) {
        self = .string(stringValue)
    }

    public init?(intValue: Int) {
        self = .int(intValue)
    }
}

extension PathComponent.Key: ExpressibleByStringLiteral {
    public init(stringLiteral value: StringLiteralType) {
        self = .string(value)
    }
}

extension PathComponent.Key: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: IntegerLiteralType) {
        self = .int(value)
    }
}

extension PathComponent.Key: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case let (.string(lhs), .string(rhs)):
            return lhs == rhs
        case let (.int(lhs), .int(rhs)):
            return lhs == rhs
        default:
            return false
        }
    }
}

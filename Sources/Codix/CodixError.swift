// CodixError.swift
// Copyright (c) 2023 Nostudio
// Created by Jerry X T Wang on 2023/3/7.

import Foundation

public enum CodixError: Error {
    public struct Context {
        public let codingPath: [CodingKey]
        public let debugDescription: String
    }

    case transformFailed(String)
    case indexOutOfRange(Context)
    case invalidKey(Context)
    case valueNotFound(String)
}

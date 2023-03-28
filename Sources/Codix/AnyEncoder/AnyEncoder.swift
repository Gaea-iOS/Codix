// AnyEncoder.swift
// Copyright (c) 2023 Nostudio
// Created by Jerry X T Wang on 2023/3/7.

import Foundation

public protocol AnyEncoder: AnyObject {
    var userInfo: [CodingUserInfoKey: Any] { get set }
    func encode(_ value: some Encodable) throws -> Data
}

public extension JSONEncoder: AnyEncoder {}
public extension PropertyListEncoder: AnyEncoder {}

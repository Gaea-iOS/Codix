// AnyDecoder.swift
// Copyright (c) 2023 Nostudio
// Created by Jerry X T Wang on 2023/3/7.

import Foundation

public protocol AnyDecoder: AnyObject {
    var userInfo: [CodingUserInfoKey: Any] { get set }
    func decode<T>(_ type: T.Type, from data: Data) throws -> T where T: Decodable
}

extension JSONDecoder: AnyDecoder {}
extension PropertyListDecoder: AnyDecoder {}

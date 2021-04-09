//
//  AnyDecoder.swift
//  Codix
//
//  Created by Jerrywang on 2021/4/9.
//

import Foundation

public protocol AnyDecoder: AnyObject {
    var userInfo: [CodingUserInfoKey: Any] { get set }
    func decode<T>(_ type: T.Type, from data: Data) throws -> T where T: Decodable
}

extension JSONDecoder: AnyDecoder {}
extension PropertyListDecoder: AnyDecoder {}

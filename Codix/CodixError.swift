//
//  CodixError.swift
//  Codix
//
//  Created by Jerrywang on 2021/4/9.
//

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

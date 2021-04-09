//
//  Transformer.swift
//  Codix
//
//  Created by Jerrywang on 2021/4/9.
//

import Foundation

public protocol Transformer {
    associatedtype From
    associatedtype To
    func transform(_ value: From) throws -> To
}

/** Not a type unwrapped, type unwrapped must take a Transformer as init parameter. */
struct AnyTransformer<I, O>: Transformer {
    private let _transform: (I) throws -> O

    init(_ transform: @escaping (I) throws -> O) {
        _transform = transform
    }

    func transform(_ value: I) throws -> O {
        return try _transform(value)
    }
}

//
// Copyright (c) 2021 Jerry Wang <4452242970@qq.com>
//

import Foundation

struct TransparentTransformer<Value>: Transformer {
    func transform(_ value: Value) throws -> Value {
        value
    }
}

@propertyWrapper
final class Decoded<Value, Trans> where Trans: Transformer, Trans.To == Value {
    /** the decode path */
    private let path: Path?

    /** Indicate whether path must present or not. */
    private let isRequired: Bool

    /** The data transformer */
    private let transformer: Trans

    var wrappedValue: Value

    init(wrappedValue: Value,
         path: Path? = nil,
         isRequired: Bool = false,
         using transformer: Trans)
    {
        self.wrappedValue = wrappedValue
        self.path = path
        self.isRequired = isRequired
        self.transformer = transformer
    }

    init(wrappedValue: Value,
         path: Path? = nil,
         isRequired: Bool = false,
         using transformer: Trans = TransparentTransformer<Value>())
        where Trans == TransparentTransformer<Value>
    {
        self.wrappedValue = wrappedValue
        self.path = path
        self.isRequired = isRequired
        self.transformer = transformer
    }
}

extension Decoded: PropertyWrapperDecoding where Trans.From: Decodable {
    func decode(from decoder: Decoder, forLabel label: String) throws {
        // Compiler will auto generate a internal property named "_{property_name}" for the property wrapped by property wrapper.
        // Refer to Language Guide/Properties of book <The Swift Programming Language (Swift 5.2)>
        let path = self.path ?? Path(label.removingPrefix("_"))
        if isRequired {
            wrappedValue = try decoder.decode(at: path, using: transformer)
        } else {
            if let value = try decoder.decodeIfPresent(at: path, using: transformer) {
                wrappedValue = value
            }
        }
    }
}

extension String {
    func removingPrefix(_ prefix: String) -> String {
        guard hasPrefix(prefix) else {
            return self
        }
        return String(dropFirst(prefix.count))
    }
}

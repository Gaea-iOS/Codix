//
// Copyright (c) 2021 Jerry Wang <4452242970@qq.com>
//

import Foundation

struct IntFromString: Transformer {
    func transform(_ value: String) throws -> Int {
        guard let decimal = Int(value) else {
            throw CodixError.transformFailed("Can not transform Int from String \(value)")
        }
        return decimal
    }
}

struct DoubleFromString: Transformer {
    func transform(_ value: String) throws -> Double {
        guard let decimal = Double(value) else {
            throw CodixError.transformFailed("Can not transform Double from String \(value)")
        }
        return decimal
    }
}

struct DecimalFromString: Transformer {
    func transform(_ value: String) throws -> Decimal {
        guard let decimal = Decimal(string: value) else {
            throw CodixError.transformFailed("Can not transform Decimal from String \(value)")
        }
        return decimal
    }
}

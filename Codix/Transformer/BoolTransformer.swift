//
// Copyright (c) 2021 Jerry Wang <4452242970@qq.com>
//

import Foundation

struct BoolFromInt: Transformer {
    func transform(_ value: Int) throws -> Bool {
        value != 0
    }
}

struct BoolFromString: Transformer {
    private let map: [String: Bool]

    init(map: [String: Bool] = ["true": true, "false": false]) {
        self.map = map
    }

    func transform(_ value: String) throws -> Bool {
        if let bool = map[value] {
            return bool
        } else {
            throw CodixError.transformFailed("Can not transfrom Bool from String \(value)")
        }
    }
}

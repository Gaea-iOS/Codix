//
// Copyright (c) 2021 Jerry Wang <4452242970@qq.com>
//

import Foundation

protocol PropertyWrapperDecoding {
    mutating func decode(from decoder: Decoder, forLabel label: String) throws
}

protocol Codixable: Decodable {
    init()
}

extension Codixable {
    init(from decoder: Decoder) throws {
        self.init()

        for child in Mirror(reflecting: self).children {
            guard var decodingValue = child.value as? PropertyWrapperDecoding,
                  let label = child.label
            else {
                continue
            }
            try decodingValue.decode(from: decoder, forLabel: label)
        }
    }
}

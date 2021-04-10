//
// Copyright (c) 2021 Jerry Wang <4452242970@qq.com>
//

import Foundation

public enum PathComponent {
    public enum Key {
        case string(String)
        case int(Int)
    }

    case key(Key)
    case index(Int)
}

extension PathComponent: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self = .key(.string(value))
    }
}

extension PathComponent: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: IntegerLiteralType) {
        self = .index(value)
    }
}

extension PathComponent: Equatable {}

//
// Copyright (c) 2021 Jerry Wang <4452242970@qq.com>
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

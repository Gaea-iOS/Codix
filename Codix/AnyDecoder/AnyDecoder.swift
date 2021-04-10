//
// Copyright (c) 2021 Jerry Wang <4452242970@qq.com>
//

import Foundation

public protocol AnyDecoder: AnyObject {
    var userInfo: [CodingUserInfoKey: Any] { get set }
    func decode<T>(_ type: T.Type, from data: Data) throws -> T where T: Decodable
}

extension JSONDecoder: AnyDecoder {}
extension PropertyListDecoder: AnyDecoder {}

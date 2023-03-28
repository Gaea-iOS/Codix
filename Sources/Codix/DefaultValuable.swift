//
//  File.swift
//  
//
//  Created by Jerrywang on 2023/3/28.
//

import Foundation

public protocol DefaultValuable {
    static var defaultValue: Self { get }
}

extension Int: DefaultValuable {
    public static var defaultValue: Self { .zero }
}

extension Bool: DefaultValuable {
    public static var defaultValue: Self { false }
}

extension String: DefaultValuable {
    public static var defaultValue: Self { "" }
}

extension Optional: DefaultValuable {
    public static var defaultValue: Self { .none }
}

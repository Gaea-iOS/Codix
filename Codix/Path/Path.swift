//
//  Path.swift
//  Codix
//
//  Created by Jerrywang on 2021/4/8.
//

import Foundation

public struct Path {
    let components: [PathComponent]

    public init(_ components: [PathComponent]) {
        self.components = components
    }

    public init(_ path: String, separator: Character = ".") {
        func unwrap(part: String) -> [PathComponent] {
            guard let regex = try? NSRegularExpression(pattern: #"\[\d+\]"#) else {
                return []
            }
            let matches = regex.matches(in: part)

            let matchRanges = matches.map(\.range)
            let points = matchRanges.map { [$0.location, $0.location + $0.length] }.flatten()
            let fullPoints = [0] + points + [(part as NSString).length]

            let ranges: [NSRange] = (1 ..< fullPoints.count).map { index in
                let location = fullPoints[index - 1]
                let length = fullPoints[index] - fullPoints[index - 1]
                return length == 0 ? nil : NSRange(location: location, length: length)
            }.filterNil()

            let components: [PathComponent] = ranges.map { range in
                if matchRanges.contains(range) {
                    var index = (part as NSString).substring(with: range)
                    index.removeFirst()
                    index.removeLast()
                    let indexComponent: PathComponent? = Int(index).flatMap { .index($0) }
                    return indexComponent
                } else {
                    let key = (part as NSString).substring(with: range)
                    let keyComponent: PathComponent = .key(.string(key))
                    return keyComponent
                }
            }.filterNil()

            return components
        }

        let parts = path.split(separator: separator).map(String.init)
        components = parts.map(unwrap(part:)).flatten()
    }
}

extension Path: ExpressibleByStringLiteral {
    public init(stringLiteral value: StringLiteralType) {
        self.init(value)
    }
}

extension Path: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: PathComponent...) {
        self.init(elements)
    }
}

private extension NSRegularExpression {
    func matches(in string: String, options: NSRegularExpression.MatchingOptions = []) -> [NSTextCheckingResult] {
        let range = NSRange(string.startIndex ..< string.endIndex, in: string)
        return matches(in: string, options: options, range: range)
    }
}

private extension Array {
    func filterNil<U>() -> [U] where Element == U? {
        compactMap { $0 }
    }

    func flatten<E>() -> [E] where Element == [E] {
        flatMap { $0 }
    }
}

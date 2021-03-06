//
// Copyright (c) 2021 Jerry Wang <4452242970@qq.com>
//

import Foundation

struct DateFromString: Transformer {
    private let formatter: DateFormatter

    init(formatter: DateFormatter) {
        self.formatter = formatter
    }

    init(format: String) {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        self.init(formatter: formatter)
    }

    func transform(_ value: String) throws -> Date {
        if let date = formatter.date(from: value) {
            return date
        } else {
            throw CodixError.transformFailed("Can not transform Date from String \(value)")
        }
    }
}

struct DateFromTimeIntervalSince1970: Transformer {
    enum TimeIntervalUnit {
        case second
        case millisecond
    }

    private let unit: TimeIntervalUnit

    init(unit: TimeIntervalUnit) {
        self.unit = unit
    }

    private func seconds(of timeInterval: TimeInterval) -> TimeInterval {
        switch unit {
        case .second:
            return timeInterval
        case .millisecond:
            return timeInterval / 1000
        }
    }

    func transform(_ value: TimeInterval) throws -> Date {
        return Date(timeIntervalSince1970: seconds(of: value))
    }
}

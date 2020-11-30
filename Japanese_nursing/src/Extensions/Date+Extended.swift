//
//  Date+Extended.swift
//  Japanese_nursing
//
//  Created by 吉澤優衣 on 2020/11/30.
//  Copyright © 2020 吉澤優衣. All rights reserved.
//

import Foundation

extension DateFormatter {

    public static var defaultFormatter: DateFormatter = {
        let f = DateFormatter()
        f.calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        f.locale = Locale(identifier: "en_US_POSIX")
        f.timeZone = TimeZone.current
        return f
    }()

    public func format(_ dateFormat: String) -> DateFormatter {
        self.dateFormat = dateFormat
        return self
    }

}

extension Date {

    fileprivate var defaultFormatter: DateFormatter {
        return DateFormatter.defaultFormatter
    }

    public func toString(_ fotmat: String) -> String {
        return self.defaultFormatter.format(fotmat).string(from: self)
    }

}

//
//  StringExts.swift
//  FavoriteList
//
//  Created by Justin Haung on 2022/7/20.
//

import Foundation

extension String {
    func date(_ formater: Date.Formatter, isGMT: Bool = false) -> Date? {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = formater.rawValue
        dateFormater.timeZone = isGMT ? TimeZone(abbreviation: "UTC") : TimeZone.current
        return dateFormater.date(from: self)
    }
}

//
//  DateExts.swift
//  FavoriteList
//
//  Created by Justin Haung on 2022/7/20.
//

import Foundation

extension Date {
    enum Formatter: String {
        case full = "yyyy/M/d hh:mm a"
        case yyyyMMddTHHmmssZ = "yyyy-MM-dd'T'HH:mm:ssZ"
        case yyyyMd = "yyyy/M/d"
        case yyyyM = "yyyy/M"
        case yyyy = "yyyy"
        case hhmma = "hh:mm a"
        case HHmm = "HH:mm"
        case MMyyyy = "MM/yyyy"
        case yyyyMM = "yyyyMM"
        case MMM = "MMM"
        case MMMM = "MMMM"
        case Md = "M/d"
        case d = "d"
    }
    
    func dateFormat(_ formater: Formatter, isGMT: Bool = false) -> String {
        let formatter = DateFormatter()
        if isGMT { formatter.timeZone = TimeZone(abbreviation: "GMT") }
        formatter.dateFormat = formater.rawValue
        return formatter.string(from: self)
    }
}

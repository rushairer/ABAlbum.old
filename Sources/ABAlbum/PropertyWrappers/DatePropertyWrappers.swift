//
//  DatePropertyWrappers.swift
//  ABAlbum
//
//  Created by Abenx on 2021/8/11.
//

import Foundation

@propertyWrapper
struct DateAndTimeFormatDate {
    static private let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter
    }()
    var wrappedValue: Date?
    var projectedValue: String { (wrappedValue != nil) ? DateAndTimeFormatDate.formatter.string(from: wrappedValue!) : "" }
}

@propertyWrapper
struct DateFormatDate {
    static private let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    var wrappedValue: Date?
    var projectedValue: String { (wrappedValue != nil) ? DateFormatDate.formatter.string(from: wrappedValue!) : "" }
}

@propertyWrapper
struct TimeFormatDate {
    static private let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        return formatter
    }()
    var wrappedValue: Date?
    var projectedValue: String { (wrappedValue != nil) ? TimeFormatDate.formatter.string(from: wrappedValue!) : "" }
}


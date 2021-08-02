//
//  Date+ABAlbum.swift
//  ABAlbum
//
//  Created by Abenx on 2021/8/2.
//

import Foundation

extension Date {
    var stringValue: String {
        get {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            return formatter.string(from: self)
        }
    }
    
    var dateStringValue: String {
        get {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            return formatter.string(from: self)
        }
    }
    
    var timeStringValue: String {
        get {
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm:ss"
            return formatter.string(from: self)
        }
    }
}

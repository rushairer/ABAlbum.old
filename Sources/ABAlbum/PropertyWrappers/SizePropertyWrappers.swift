//
//  SizePropertyWrappers.swift
//  ABAlbum
//
//  Created by Abenx on 2021/8/11.
//

import SwiftUI

@propertyWrapper
struct CellSize {
    private let number: Int
    private let spacing: CGFloat
    private var size: CGSize
    
    init(wrappedValue: CGSize, number: Int, spacing: CGFloat = 0) {
        self.size = wrappedValue
        self.number = number
        self.spacing = spacing
    }
    
    var wrappedValue: CGSize {
        get {
            let width = floor((min(size.width, size.height) - spacing * (CGFloat(number) + 1)) / CGFloat(number))
            return CGSize(width: width, height: width)
        }
        set { size = newValue }
    }
}

@propertyWrapper
struct ScreenScaledSize {
    private var size: CGSize

    init(wrappedValue: CGSize) {
        self.size = wrappedValue
    }
    
    var wrappedValue: CGSize {
        get {
            let scale = UIScreen.main.scale
            return CGSize(width: size.width * scale, height: size.height * scale)
        }
        set { size = newValue }
    }
}

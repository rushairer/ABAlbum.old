//
//  Screen.swift
//  ABAlbum
//
//  Created by Abenx on 2021/7/31.
//

import Foundation
import SwiftUI

struct Screen {
    static let main = Screen()
    
    #if os(macOS)
    public var scale: CGFloat {
        get {
            return NSScreen.main?.backingScaleFactor ?? 1
        }
    }
    #else
    public var scale: CGFloat {
        get {
            return UIScreen.main.scale
        }
    }
    #endif
}

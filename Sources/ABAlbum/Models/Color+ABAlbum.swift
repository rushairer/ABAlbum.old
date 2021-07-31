//
//  File.swift
//  File
//
//  Created by Abenx on 2021/7/31.
//

import SwiftUI

#if os(macOS)
extension Color {
    public init(uiColor: NSColor) {
        self.init(nsColor: uiColor)
    }
}

extension NSColor {
    public static var label: NSColor {
        return .labelColor
    }
    
    public static var tertiarySystemGroupedBackground: NSColor {
        return .windowBackgroundColor
    }
}
#endif

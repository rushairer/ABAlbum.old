//
//  Image+ABAlbum.swift
//  ABAlbum
//
//  Created by Abenx on 2021/7/31.
//

import SwiftUI

#if os(macOS)
public typealias UIImage = NSImage

extension Image {
    public init(uiImage: NSImage) {
        self.init(nsImage: uiImage)
    }
}

extension UIImage {
    public convenience init?(named name: String, in bundle: Bundle?, with configuration: NSImage.SymbolConfiguration?) {
        self.init(named: name)
    }
}
#endif



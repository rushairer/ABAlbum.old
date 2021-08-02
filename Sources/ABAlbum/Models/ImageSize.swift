//
//  ImageSize.swift
//  ABAlbum
//
//  Created by Abenx on 2021/8/1.
//

import SwiftUI

enum ImageSize: Int, CaseIterable {
    case small = 960
    case medium = 1280
    case large = 2048
    case raw = 4096
    
    public var size: CGSize {
        return CGSize(width: self.rawValue, height: self.rawValue)
    }
}

//
//  MediaType.swift
//  ABAlbum
//
//  Created by Abenx on 2021/7/30.
//

import Foundation

/// The mediatype of assets.
public enum MediaType: Int, CaseIterable {
    /// Both image and video.
    case both = 0

    /// Image only.
    case image = 1

    /// Video only.
    case video = 2
}

//
//  MediaType.swift
//  ABAlbum
//
//  Created by Abenx on 2021/7/30.
//

import Foundation

/// 媒体类型.
public enum MediaType: Int, CaseIterable {
    /// 照片和视频
    case both = 0

    /// 仅照片
    case image = 1

    /// 仅视频
    case video = 2
}

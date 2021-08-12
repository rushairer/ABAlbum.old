//
//  ImageFetchOptions.swift
//  ABAlbum
//
//  Created by Abenx on 2021/8/12.
//

import Foundation
import Photos

struct ImageFetchOptions {
    static func fetchOptions(isNetworkAccessAllowed: Bool = true) -> PHImageRequestOptions {
        let option = PHImageRequestOptions()
        option.isNetworkAccessAllowed = isNetworkAccessAllowed
        return option
    }
}

//
//  PHImageRequestOptions+ABAlbum.swift
//  ABAlbum
//
//  Created by Abenx on 2021/8/9.
//

import Photos

extension PHImageRequestOptions {
    class func defaultImageRequestOptions() -> PHImageRequestOptions {
        return PHImageRequestOptions(isNetworkAccessAllowed: true)
    }
    
    convenience init(isNetworkAccessAllowed: Bool) {
        self.init()
        self.isNetworkAccessAllowed = isNetworkAccessAllowed
    }
}

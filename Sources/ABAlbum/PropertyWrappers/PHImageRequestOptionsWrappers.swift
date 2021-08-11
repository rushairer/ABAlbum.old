//
//  PHImageRequestOptionsWrappers.swift
//  ABAlbum
//
//  Created by Abenx on 2021/8/11.
//

import Foundation
import Photos

@propertyWrapper
struct DefaultImageRequestOptions {
    private let isNetworkAccessAllowed: Bool
    
    init(isNetworkAccessAllowed: Bool = true) {
        self.isNetworkAccessAllowed = isNetworkAccessAllowed
    }
    
    var wrappedValue: PHImageRequestOptions {
        get {
            let option = PHImageRequestOptions()
            option.isNetworkAccessAllowed = isNetworkAccessAllowed
            return option
        }
    }
}

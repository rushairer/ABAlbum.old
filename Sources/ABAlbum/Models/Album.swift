//
//  Album.swift
//  ABAlbum
//
//  Created by Abenx on 2021/8/12.
//

import Foundation
import Photos

struct Album {
    var assetCollection: PHAssetCollection
    
    var title: String {
        get {
            return assetCollection.localizedTitle ?? "Untitled"
        }
    }
    
    var localIdentifier: String {
        get {
            return assetCollection.localIdentifier
        }
    }
    
    var assetsResult: PHFetchResult<PHAsset>?
    
    mutating func fetchAssets(with fetchOptions: PHFetchOptions?) {
        assetsResult = PHAsset.fetchAssets(in: assetCollection, options: fetchOptions)
    }
}

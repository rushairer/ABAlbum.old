//
//  Album.swift
//  ABAlbum
//
//  Created by Abenx on 2021/8/12.
//

import Foundation
import Photos

struct Album: Identifiable {
    var id: String {
        get {
            return "\(String(describing: assetCollection.localIdentifier))_\(String(describing: assetsResult?.firstObject?.localIdentifier))"
        }
    }
    
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
    
    mutating func fetchAssets(with fetchOptions: AlbumFetchOptions?) {
        assetsResult = PHAsset.fetchAssets(in: assetCollection, options: fetchOptions?.rawValue)
    }
}

extension Album: Equatable {
    public static func == (lhs: Album, rhs: Album) -> Bool {
        return lhs.localIdentifier == rhs.localIdentifier &&
        lhs.assetsResult == rhs.assetsResult &&
        lhs.assetCollection == rhs.assetCollection
    }
}

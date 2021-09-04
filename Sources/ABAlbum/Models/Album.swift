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
            return "\(String(describing: assetCollection.localIdentifier))_\(String(describing: assets?.first?.localIdentifier))"
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
    
    var fetchOptions: AlbumFetchOptions?
    
    var assetsResult: PHFetchResult<PHAsset>?
        
    var assets: [PHAsset]?
    
    mutating func fetchAssets(with fetchOptions: AlbumFetchOptions?) {
        self.assetsResult  = PHAsset.fetchAssets(in: assetCollection, options: fetchOptions?.rawValue)
        
        asyncAssets()
    }
    
    mutating func asyncAssets() {
        guard let assetsResult = self.assetsResult else {
            assets = []
            return
        }
        let count = assetsResult.count > 0 ? assetsResult.count - 1 : 0
        let range = IndexSet(integersIn: 0..<count)
        assets = assetsResult.objects(at: range)
    }
}

extension Album: Equatable {
    public static func == (lhs: Album, rhs: Album) -> Bool {
        return lhs.localIdentifier == rhs.localIdentifier &&
        lhs.assets == rhs.assets &&
        lhs.assetCollection == rhs.assetCollection
    }
}

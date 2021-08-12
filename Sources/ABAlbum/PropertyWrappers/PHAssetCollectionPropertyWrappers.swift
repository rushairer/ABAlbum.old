//
//  PHAssetCollectionPropertyWrappers.swift
//  ABAlbum
//
//  Created by Abenx on 2021/8/12.
//

import Foundation
import Photos

@propertyWrapper
struct CollectionFetchRequest {
    private let fetchOptions: PHFetchOptions?
    var wrappedValue: PHAssetCollection
    
    var projectedValue: PHFetchResult<PHAsset>? {
        get {
            return PHAsset.fetchAssets(in: wrappedValue, options: fetchOptions)
        }
    }
    
    init(wrappedValue: PHAssetCollection, fetchOptions: PHFetchOptions?) {
        self.wrappedValue = wrappedValue
        self.fetchOptions = fetchOptions
    }
}

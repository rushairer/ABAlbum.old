//
//  PHAssetCollection+ABAlbum.swift
//  ABAlbum
//
//  Created by Abenx on 2021/7/29.
//

import Foundation
import Photos

extension PHAssetCollection {
    private struct associatedKey {
        static var assetsResult: PHFetchResult<PHAsset>?
        static var fetchOptions: PHFetchOptions?
    }
    
    /// 图片资源请求结果.
    var assetsResult: PHFetchResult<PHAsset>? {
        get {
            let result = objc_getAssociatedObject(self, &associatedKey.assetsResult) as? PHFetchResult<PHAsset>
            guard result == nil else { return result }
            
            let newResult = PHAsset.fetchAssets(in: self, options: self.fetchOptions)
            objc_setAssociatedObject(self, &associatedKey.assetsResult, newResult, .OBJC_ASSOCIATION_COPY_NONATOMIC)
            return newResult
        }
    }
    
    /// 请求配置.
    var fetchOptions: PHFetchOptions? {
        get {
            return objc_getAssociatedObject(self, &associatedKey.fetchOptions) as? PHFetchOptions ?? nil
        }
        set {
            objc_setAssociatedObject(self, &associatedKey.fetchOptions, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
}

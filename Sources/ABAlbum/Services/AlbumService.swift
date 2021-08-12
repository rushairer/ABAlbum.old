//
//  AlbumService.swift
//  ABAlbum
//
//  Created by Abenx on 2021/7/28.
//

import SwiftUI
import Photos

/// Get collections and assets.
struct AlbumService {
    
    static let imageManager = PHCachingImageManager()
    
    /// Register the PHPhotoLibraryChangeObserver, if PHAuthorizationStatus is .notDetermined will be skipped.
    /// - Parameter observer: PHPhotoLibraryChangeObserver
    static func registerChangeObserver(_ observer: PHPhotoLibraryChangeObserver) {
        guard AlbumAuthorizationStatus.isDetermined else { return }
        PHPhotoLibrary.shared().register(observer)
    }
    
    /// Unregister the PHPhotoLibraryChangeObserver, if PHAuthorizationStatus is .notDetermined will be skipped.
    /// - Parameter observer: PHPhotoLibraryChangeObserver
    static func unregisterChangeObserver(_ observer: PHPhotoLibraryChangeObserver) {
        guard AlbumAuthorizationStatus.isDetermined else { return }
        PHPhotoLibrary.shared().unregisterChangeObserver(observer)
    }
    
    static func allAlbums(with fetchOptions: PHFetchOptions) -> [Album] {
        guard AlbumAuthorizationStatus.isDetermined else {
            return []
        }
        
        let smartAlbums = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .any, options: nil)
        let userAlbums = PHCollectionList.fetchTopLevelUserCollections(with: nil) as! PHFetchResult<PHAssetCollection>
        let allAlbums: [PHFetchResult<PHAssetCollection>] = [smartAlbums, userAlbums]
        
        var albums: [Album] = []
        allAlbums.forEach { fetchResult in
            fetchResult.enumerateObjects { (collection, _, _) in
                guard collection.isKind(of: PHAssetCollection.self) else { return }
                guard collection.estimatedAssetCount > 0 else { return }
                guard collection.assetCollectionSubtype.rawValue != 1000000201
                        && collection.assetCollectionSubtype != PHAssetCollectionSubtype.smartAlbumAllHidden else { return }
                
                var album = Album(assetCollection: collection)
                album.fetchAssets(with: fetchOptions)
                
                guard let resut = album.assetsResult,
                      resut.count > 0 else { return }
                if collection.assetCollectionSubtype == PHAssetCollectionSubtype.smartAlbumUserLibrary {
                    albums.insert(album, at: 0)
                } else if collection.localizedTitle == Bundle.main.object(forInfoDictionaryKey: kCFBundleNameKey as String) as? String {
                    albums.insert(album, at: (albums.count > 0 ? 1 : 0))
                } else {
                    albums.append(album)
                }
            }
        }
        return albums
    }
    
    static func startCachingImages(for assets: [PHAsset], size: CGSize, requestOptions: PHImageRequestOptions?) {
        guard AlbumAuthorizationStatus.isDetermined else { return }
        AlbumService.imageManager.startCachingImages(for: assets, targetSize: size, contentMode: .aspectFill, options: requestOptions)
    }
    
    static func stopCachingImages(for assets: [PHAsset], size: CGSize, requestOptions: PHImageRequestOptions?) {
        guard AlbumAuthorizationStatus.isDetermined else { return }
        AlbumService.imageManager.stopCachingImages(for: assets, targetSize: size, contentMode: .aspectFill, options: requestOptions)
    }
    
    /// 异步请求PHAsset的UIImage
    ///
    /// - Parameters:
    ///   - asset: 图片资源
    ///   - size: 图片尺寸
    ///   - requestOptions: 图片请求参数
    /// - Returns: 异步队列
    ///
    static func asyncImage(from asset: PHAsset, size: CGSize, requestOptions: PHImageRequestOptions?) ->  AsyncThrowingStream<UIImage, Error> {
        return AsyncThrowingStream<UIImage, Error> { continuation in
            guard AlbumAuthorizationStatus.isDetermined else {
                continuation.finish(throwing: AlbumError.authorizationStatus(.notDetermined))
                return
            }
            
            AlbumService.imageManager
                .requestImage(for: asset, targetSize: size, contentMode: .aspectFill, options: requestOptions) { image, info  in
                    guard let info = info, let image = image else { return }
                    
                    if let _ = info[PHImageErrorKey] {
                        continuation.finish(throwing: AlbumError.requestImageFailed)
                        return
                    }
                    
                    if let _ = info[PHImageCancelledKey],
                       info[PHImageCancelledKey] as! Bool {
                        continuation.finish(throwing: AlbumError.isCancelled)
                        return
                    }
                    
                    continuation.yield(image)
                    
                    if let _ = info[PHImageResultIsDegradedKey],
                       !(info[PHImageResultIsDegradedKey] as! Bool) {
                        continuation.finish()
                    }
                    
                    continuation.onTermination = { @Sendable terminal in
                        switch terminal {
                        case .cancelled:
                            let requestIDKey = info[PHImageResultRequestIDKey] as! PHImageRequestID
                            DispatchQueue.global(qos: .userInteractive).async {
                                AlbumService.imageManager.cancelImageRequest(requestIDKey)
                            }
                        default: break
                        }
                    }
                }
        }
    }
}

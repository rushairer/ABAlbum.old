//
//  AlbumService.swift
//  ABAlbum
//
//  Created by Abenx on 2021/7/28.
//

import SwiftUI
import Photos
import Combine

public struct AlbumService {
    public static let shared = AlbumService()
    
    static let imageManager = PHCachingImageManager()
    
    public var authorizationStatus: PHAuthorizationStatus {
        get {
            return PHPhotoLibrary.authorizationStatus(for: .readWrite)
        }
    }
    
    public var isNotDetermined: Bool {
        get {
            authorizationStatus == .notDetermined
        }
    }
    
    public var isDetermined: Bool {
        get {
            authorizationStatus != .notDetermined
        }
    }
    
    public var hasAlbumPermission: Bool {
        get async {
            var status: PHAuthorizationStatus = authorizationStatus
            if status == .notDetermined {
                status = await PHPhotoLibrary.requestAuthorization(for: .readWrite)
            }
            return status == .authorized || status == .limited
        }
    }
    
    public func registerChangeObserver(_ observer: PHPhotoLibraryChangeObserver) {
        guard isDetermined else { return }
        PHPhotoLibrary.shared().register(observer)
    }
    
    public func unregisterChangeObserver(_ observer: PHPhotoLibraryChangeObserver) {
        guard isDetermined else { return }
        PHPhotoLibrary.shared().unregisterChangeObserver(observer)
    }
    
    var options: PHFetchOptions?
    
    var mediaType: PHAssetMediaType = .unknown
    
    private var defaultOptions: PHFetchOptions {
        let option = PHFetchOptions()
        if mediaType != PHAssetMediaType.unknown {
            option.predicate = NSPredicate(format: "mediaType == %ld", mediaType.rawValue)
        }
        option.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        return option
    }
    
    var allAssetCollections: [PHAssetCollection] {
        get {
            guard isDetermined else {
                return []
            }
            
            let smartAlbums = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .any, options: nil)
            let userAlbums = PHCollectionList.fetchTopLevelUserCollections(with: nil) as! PHFetchResult<PHAssetCollection>
            let allAlbums: [PHFetchResult<PHAssetCollection>] = [smartAlbums, userAlbums]
            
            var albumCollections: [PHAssetCollection] = []
            allAlbums.forEach { fetchResult in
                fetchResult.enumerateObjects { (collection, _, _) in
                    guard collection.isKind(of: PHAssetCollection.self) else { return }
                    guard collection.estimatedAssetCount > 0 else { return }
                    guard collection.assetCollectionSubtype.rawValue != 1000000201
                            && collection.assetCollectionSubtype != PHAssetCollectionSubtype.smartAlbumAllHidden else { return }
                    
                    collection.fetchOptions = options ?? defaultOptions
                    
                    guard let resut = collection.assetsResult,
                          resut.count > 0 else { return }
                    
                    if collection.assetCollectionSubtype == PHAssetCollectionSubtype.smartAlbumUserLibrary {
                        albumCollections.insert(collection, at: 0)
                    } else if collection.localizedTitle == Bundle.main.object(forInfoDictionaryKey: kCFBundleNameKey as String) as? String {
                        albumCollections.insert(collection, at: (albumCollections.count > 0 ? 1 : 0))
                    } else {
                        albumCollections.append(collection)
                    }
                }
            }
            return albumCollections
        }
    }
    
    func startCachingImages(for assets: [PHAsset], size: CGSize, requestOptions: PHImageRequestOptions?) {
        guard isDetermined else { return }
        AlbumService.imageManager.startCachingImages(for: assets, targetSize: size, contentMode: .aspectFill, options: requestOptions)
    }
    
    func stopCachingImages(for assets: [PHAsset], size: CGSize, requestOptions: PHImageRequestOptions?) {
        guard isDetermined else { return }
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
    func asyncImage(from asset: PHAsset, size: CGSize, requestOptions: PHImageRequestOptions?) ->  AsyncThrowingStream<UIImage, Error> {
        return AsyncThrowingStream<UIImage, Error> { continuation in
            guard isDetermined else {
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
                                PHCachingImageManager.default().cancelImageRequest(requestIDKey)
                            }
                        default: break
                        }
                    }
                }
        }
    }
}

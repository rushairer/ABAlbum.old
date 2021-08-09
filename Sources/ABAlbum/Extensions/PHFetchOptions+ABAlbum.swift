//
//  PHFetchOptions+ABAlbum.swift
//  ABAlbum
//
//  Created by Abenx on 2021/8/8.
//

import Photos
import SwiftUI

extension PHFetchOptions {
    /// Create a default option for fetching collection descending by key `creationDate`.
    public class func defaultCollectionFetchOptions() -> PHFetchOptions {
        return PHFetchOptions(predicate: nil, sortDescriptors: [NSSortDescriptor(key: "creationDate", ascending: false)])
    }
    
    /// Create an option for fetching collection with ``MediaType`` descending by key `creationDate`.
    /// - Parameter mediaType: The MediaType of collection you want to fetch.
    /// - Returns: The PHFetchOptions.
    public class func collectionFetchOptions(with mediaType: MediaType) -> PHFetchOptions {
        if mediaType.rawValue != PHAssetMediaType.unknown.rawValue {
            return PHFetchOptions(predicate: NSPredicate(format: "mediaType == %ld", mediaType.rawValue),
                                  sortDescriptors: [NSSortDescriptor(key: "creationDate", ascending: false)])
        } else {
            return PHFetchOptions(predicate: nil, sortDescriptors: [NSSortDescriptor(key: "creationDate", ascending: false)])
        }
    }
    
    convenience init(predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]?) {
        self.init()
        self.predicate = predicate
        self.sortDescriptors = sortDescriptors
    }
}

extension EnvironmentValues {
    public var albumFetchOptions: PHFetchOptions {
        get {
            return self[AlbumFetchOptionsKey.self]
        }
        set {
            self[AlbumFetchOptionsKey.self] = newValue
        }
    }
}

extension View {
    public func albumFetchOptions(_ albumFetchOptions: PHFetchOptions) -> some View {
        environment(\.albumFetchOptions, albumFetchOptions)
    }
}

private struct AlbumFetchOptionsKey: EnvironmentKey {
    static let defaultValue: PHFetchOptions = .defaultCollectionFetchOptions()
}

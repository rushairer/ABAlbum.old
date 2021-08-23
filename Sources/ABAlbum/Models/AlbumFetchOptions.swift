//
//  AlbumFetchOptions.swift
//  ABAlbum
//
//  Created by Abenx on 2021/8/12.
//

import SwiftUI
import Photos

/// Create the AlbumFetchOptions for Album.
///
/// ```swift
/// AlbumPage(showsAlbumNoPermissionView: $showsAlbumNoPermissionView)
///     .albumFetchOptions(.fetchOptions(with: .both)
/// ```
public struct AlbumFetchOptions {
    
    /// The rawValue of AlbumFetchOptions.
    public private(set) var rawValue: PHFetchOptions

    /// Create a AlbumFetchOptions
    ///
    /// Create a AlbumFetchOptions for albums with ``MediaType``.
    ///
    /// - Parameter mediaType: The ``MediaType`` of albums.
    /// - Returns: A AlbumFetchOptions.
    public static func fetchOptions(with mediaType: MediaType? = .both) -> AlbumFetchOptions {
        let option = PHFetchOptions()
        option.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        if let mediaType = mediaType,
           mediaType.rawValue != PHAssetMediaType.unknown.rawValue {
            option.predicate = NSPredicate(format: "mediaType == %ld", mediaType.rawValue)
        }
        
        return AlbumFetchOptions(rawValue: option)
    }
    
}

extension EnvironmentValues {
    public var albumFetchOptions: AlbumFetchOptions {
        get {
            return self[AlbumFetchOptionsKey.self]
        }
        set {
            self[AlbumFetchOptionsKey.self] = newValue
        }
    }
}

extension View {
    public func albumFetchOptions(_ albumFetchOptions: AlbumFetchOptions) -> some View {
        environment(\.albumFetchOptions, albumFetchOptions)
    }
}

private struct AlbumFetchOptionsKey: EnvironmentKey {
    static let defaultValue: AlbumFetchOptions = .fetchOptions(with: .both)
}

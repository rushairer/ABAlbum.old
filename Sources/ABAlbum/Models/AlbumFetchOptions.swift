//
//  AlbumFetchOptions.swift
//  ABAlbum
//
//  Created by Abenx on 2021/8/12.
//

import SwiftUI
import Photos

/// Create the PHFetchOptions for Album.
///
/// ```swift
/// AlbumPage()
///     .showsNoPermissionView($showsAlbumNoPermissionView)
///     .albumFetchOptions(AlbumFetchOptions.fetchOptions(with: .both)
/// ```
public struct AlbumFetchOptions {
    /// Create a PHFetchOptions
    ///
    /// Create a PHFetchOptions for albums with ``MediaType``.
    ///
    /// - Parameter mediaType: The ``MediaType`` of albums.
    /// - Returns: A PHFetchOptions.
    public static func fetchOptions(with mediaType: MediaType) -> PHFetchOptions {
        let option = PHFetchOptions()
        option.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        if mediaType.rawValue != PHAssetMediaType.unknown.rawValue {
            option.predicate = NSPredicate(format: "mediaType == %ld", mediaType.rawValue)
        }
        return option
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
    static let defaultValue: PHFetchOptions = AlbumFetchOptions.fetchOptions(with: .both)
}

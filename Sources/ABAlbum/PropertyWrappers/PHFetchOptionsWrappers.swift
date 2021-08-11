//
//  PHFetchOptionsWrappers.swift
//  ABAlbum
//
//  Created by Abenx on 2021/8/11.
//

import SwiftUI
import Photos

@propertyWrapper
public struct DefaultFetchOptions {
    public var wrappedValue: PHFetchOptions {
        get {
            let option = PHFetchOptions()
            option.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
            return option
        }
    }
    
    public init() {}
}

@propertyWrapper
public struct CollectionFetchOptions {
    private let mediaType: MediaType
        
    public init(mediaType: MediaType) {
        self.mediaType = mediaType
    }
    
    public var wrappedValue: PHFetchOptions {
        get {
            let option = PHFetchOptions()
            option.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]

            if mediaType.rawValue != PHAssetMediaType.unknown.rawValue {
                option.predicate = NSPredicate(format: "mediaType == %ld", mediaType.rawValue)
            }
            return option
        }
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
    @DefaultFetchOptions static var defaultValue: PHFetchOptions
}



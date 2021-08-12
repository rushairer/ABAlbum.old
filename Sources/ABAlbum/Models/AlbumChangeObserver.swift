//
//  AlbumChangeObserver.swift
//  ABAlbum
//
//  Created by Abenx on 2021/8/7.
//

import SwiftUI
import Photos

class AlbumChangeObserver: NSObject, ObservableObject, PHPhotoLibraryChangeObserver {
    @Published var changeInstance: PHChange?
    
    override init() {
        super.init()
        AlbumService.registerChangeObserver(self)
    }
    
    deinit {
        AlbumService.unregisterChangeObserver(self)
    }
    
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        DispatchQueue.main.async {
            self.changeInstance = changeInstance
        }
    }
}

extension EnvironmentValues {
    var albumChangeObserver: AlbumChangeObserver {
        get {
            return self[AlbumChangeObserverKey.self]
        }
        set {
            self[AlbumChangeObserverKey.self] = newValue
        }
    }
}

private struct AlbumChangeObserverKey: EnvironmentKey {
    static let defaultValue: AlbumChangeObserver = AlbumChangeObserver()
}


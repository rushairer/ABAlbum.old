//
//  AlbumViewModel.swift
//  ABAlbum
//
//  Created by Abenx on 2021/8/12.
//

import SwiftUI
import Photos
import Combine

class AlbumViewModel: ObservableObject {
    @Published var currentAssetLocalIdentifier: String?
    
    @Published var allAlbums: [Album]?
    
    @Published var currentAlbum: Album?
    
    @Published var albumChange: AlbumChange = AlbumChange()
    
    var albumFetchOptions: AlbumFetchOptions?
    
    var changedObserver: AlbumChangeObserver?
    
    var cancellables = Set<AnyCancellable>()
    
    var albumChangeSubscriber: AnySubscriber<PHChange, Never> {
        get {
            let subscriber = AnySubscriber<PHChange, Never> { subscription in
                subscription.request(.unlimited)
            } receiveValue: { [unowned self] change in
                guard currentAlbum != nil else { return .none }
                if let changeDetails = change.changeDetails(for: currentAlbum!.assetsResult!) {
                    currentAlbum?.assetsResult = changeDetails.fetchResultAfterChanges
                }

                allAlbums = allAlbums?.map({ album in
                    if album.localIdentifier == currentAlbum?.localIdentifier {
                        return currentAlbum!
                    } else {
                        return album
                    }
                })
                
                return .none
            } receiveCompletion: { completion in
            }
            return subscriber
        }
    }
    
    init() {
        changedObserver = AlbumChangeObserver(subscriber: albumChangeSubscriber)
        if changedObserver != nil {
            AlbumService.registerChangeObserver(changedObserver!)
        }
    }
    
    deinit {
        if changedObserver != nil {
            AlbumService.unregisterChangeObserver(changedObserver!)
        }
    }
}

extension AlbumViewModel {
    struct AlbumChange {
        var changeInstance: PHChange?
    }
    
    class AlbumChangeObserver: NSObject, PHPhotoLibraryChangeObserver {
        var subscriber: AnySubscriber<PHChange, Never>
        
        init(subscriber: AnySubscriber<PHChange, Never>) {
            self.subscriber = subscriber
            super.init()
        }
        
        func photoLibraryDidChange(_ changeInstance: PHChange) {
            DispatchQueue.main.async { [unowned self] in
                Just(changeInstance).receive(subscriber: self.subscriber)
            }
        }
    }
}

extension AlbumViewModel {
    func requestAlbums(with albumFetchOptions: AlbumFetchOptions?) {
        self.albumFetchOptions = albumFetchOptions
        allAlbums = AlbumService.allAlbums(with: albumFetchOptions)
    }
    
    func clearAlbum() {
        allAlbums?.removeAll()
        allAlbums = nil
    }
}

extension EnvironmentValues {
    var albumViewModel: AlbumViewModel {
        get {
            return self[AlbumViewModelKey.self]
        }
        
        set {
            self[AlbumViewModelKey.self] = newValue
        }
    }
}

private struct AlbumViewModelKey: EnvironmentKey {
    static let defaultValue: AlbumViewModel = AlbumViewModel()
}

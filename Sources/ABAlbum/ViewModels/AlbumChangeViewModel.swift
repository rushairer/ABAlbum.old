//
//  AlbumChangeViewModel.swift
//  ABAlbum
//
//  Created by Abenx on 2021/8/7.
//

import SwiftUI
import Photos
import Combine

class AlbumChangeViewModel: ObservableObject {
    
    @Published var albumChange: AlbumChange = AlbumChange()

    var changedObserver: AlbumChangeObserver?
    
    var albumChangeSubscriber: AnySubscriber<PHChange, Never> {
        get {
            let subscriber = AnySubscriber<PHChange, Never> { subscription in
                subscription.request(.unlimited)
            } receiveValue: { [unowned self] change in
                self.albumChange.changeInstance = change
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

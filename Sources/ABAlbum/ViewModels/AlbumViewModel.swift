//
//  AlbumViewModel.swift
//  ABAlbum
//
//  Created by Abenx on 2021/8/12.
//

import SwiftUI

class AlbumViewModel: ObservableObject {
    @Published var currentAssetLocalIdentifier: String?
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

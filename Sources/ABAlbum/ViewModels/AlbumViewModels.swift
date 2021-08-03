//
//  AlbumViewModels.swift
//  ABAlbum
//
//  Created by Abenx on 2021/8/3.
//

import Foundation

public class AlbumViewModels: ObservableObject {
    @Published public var currentAssetLocalIdentifier: String?
    
    public init() {}
}

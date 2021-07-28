//
//  AlbumService.swift
//  AlbumService
//
//  Created by Abenx on 2021/7/28.
//

import Foundation
import Photos

struct AlbumService {
    static let shared = AlbumService()
    
    func hasAlbumPermission() async -> Bool {
        let status: PHAuthorizationStatus = await PHPhotoLibrary.requestAuthorization(for: .readWrite)
        return status == .authorized || status == .limited
    }
}

//
//  AlbumAuthorizationStatus.swift
//  ABAlbum
//
//  Created by Abenx on 2021/8/8.
//

import Foundation
import Photos

/// Manage the PHAuthorizationStatus.
public struct AlbumAuthorizationStatus {
    /// Get PHAuthorizationStatus for PHAccessLevel.readWrite
    public static var authorizationStatus: PHAuthorizationStatus {
        return PHPhotoLibrary.authorizationStatus(for: .readWrite)
    }
    
    /// Is PHAuthorizationStatus .notDetermined or not
    public static var isNotDetermined: Bool {
        get {
            authorizationStatus == .notDetermined
        }
    }
    
    /// If PHAuthorizationStatus is not .notDetermined, will return true.
    public static var isDetermined: Bool {
        get {
            authorizationStatus != .notDetermined
        }
    }
    
    /// If PHAuthorizationStatus is .notDetermined, it will call PHPhotoLibrary.requestAuthorization(for:).
    /// Then if PHAuthorizationStatus is .authorized or .limited will return true.
    public static var hasAlbumPermission: Bool {
        get async {
            var status: PHAuthorizationStatus = authorizationStatus
            if status == .notDetermined {
                status = await PHPhotoLibrary.requestAuthorization(for: .readWrite)
            }
            return status == .authorized || status == .limited
        }
    }
}

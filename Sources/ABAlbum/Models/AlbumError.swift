//
//  AlbumError.swift
//  ABAlbum
//
//  Created by Abenx on 2021/7/29.
//

import Foundation
import Photos

/// 相册的错误类型
public enum AlbumError: Error, Identifiable {
    public var id: String { localizedDescription }
    
    /// 未知错误
    case unknown
    
    /// 相册权限相关错误
    case authorizationStatus(PHAuthorizationStatus)
    
    /// 请求照片失败
    case requestImageFailed
    
    /// 使用低分辨率预览图
    case isDegraded
    
    /// 图片请求取消
    case isCancelled
}

extension AlbumError: LocalizedError {
    var localizedDescription: String {
        switch self {
        case .unknown: return "Unknown error."
        case .authorizationStatus(let status): return "AuthorizationStatus is \(status.rawValue)."
        case .requestImageFailed: return "Request image failed."
        case .isDegraded: return "Image is degraded."
        case .isCancelled: return "Image is cancelled."
        }
    }
}

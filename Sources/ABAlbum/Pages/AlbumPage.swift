//
//  AlbumPage.swift
//  ABAlbum
//
//  Created by Abenx on 2021/7/27.
//

import SwiftUI
import Photos

public struct AlbumPage: View {
    
    /// 是否显示权限提示页. 默认: 不显示.
    @State private var showsAlbumNoPermissionView: Bool = false
    
    public init() {}
    
    private var albumNoPermissionView: some View {
        AlbumNoPermissionView()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.background)
            .opacity(showsAlbumNoPermissionView ? 1 : 0)
    }
    
    public var body: some View {
        AlbumSelectorGridView()
            .overlay(albumNoPermissionView)
            .id(showsAlbumNoPermissionView) /// 第一次启动申请时, 会造成 showsAlbumNoPermissionView 改变, 从而在授权后刷新View.
            .task {
                /// 如果未授权, 显示权限提示页.
                if AlbumService.shared.authorizationStatus == .notDetermined {
                    showsAlbumNoPermissionView = true
                }
                /// 判断是否有相册服访问权限.
                showsAlbumNoPermissionView = await !AlbumService.shared.hasAlbumPermission
            }
    }
}

struct AlbumPage_Previews: PreviewProvider {
    static var previews: some View {
        AlbumPage()
    }
}

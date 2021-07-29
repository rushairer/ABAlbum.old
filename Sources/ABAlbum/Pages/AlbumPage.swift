//
//  AlbumPage.swift
//  ABAlbum
//
//  Created by Abenx on 2021/7/27.
//

import SwiftUI

public struct AlbumPage: View {
    
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
            .task {
                showsAlbumNoPermissionView = await !AlbumService.shared.hasAlbumPermission
            }
    }
}

struct AlbumPage_Previews: PreviewProvider {
    static var previews: some View {
        AlbumPage()
    }
}

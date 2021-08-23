//
//  AlbumSelectorGridView.swift
//  ABAlbum
//
//  Created by Abenx on 2021/7/28.
//

import SwiftUI
import Photos

struct AlbumSelectorGridView: View {
    @Environment(\.albumFetchOptions) var albumFetchOptions: AlbumFetchOptions
    @Environment(\.albumViewModel) var albumViewModel: AlbumViewModel
    
    @State private var allAlbums: [Album] = []
    @State private var showsGridCellView: Bool = false
    
    private let maxColumn: Int = 2
    private let gridSpacing: CGFloat = 8
    
    private var albumEmptyView: some View {
        AlbumEmptyView()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.background)
    }
    
    var body: some View {
        func internalView(geometryProxy: GeometryProxy) -> some View {
            @CellSize(number: maxColumn, spacing: gridSpacing) var size: CGSize = geometryProxy.size
            @ScreenScaledSize var thumbnailSize:CGSize = size
            
            return ZStack {
                NavigationLink(isActive: $showsGridCellView,
                               destination: {
                    AlbumGridView()
                }) {
                    EmptyView()
                }
                ScrollView(.vertical) {
                    LazyVGrid(columns: [
                        GridItem(.adaptive(minimum: size.width,
                                           maximum: size.width),
                                 spacing: gridSpacing)
                    ]) {
                        ForEach(allAlbums, id: \.localIdentifier) { album in
                            if album.assetsResult?.firstObject != nil {
                                let localIdentifier = album.assetsResult!.firstObject!.localIdentifier
                                AlbumSelectorGridCellView(asset: album.assetsResult!.firstObject!,
                                                          size: size,
                                                          thumbnailSize: thumbnailSize,
                                                          title: album.title,
                                                          count: album.assetsResult?.count)
                                    .onTapGesture {
                                        albumViewModel.currentAlbum = album
                                        showsGridCellView = true
                                    }
                                    .frame(width: size.width, height: size.width)
                                    .id(localIdentifier) /// 设置id可以强制刷新Cell
                            }
                        }
                    }
                }
            }
            .overlay(AlbumEmptyView().opacity(allAlbums.count > 0 ? 0 : 1))
            .navigationTitle("Albums")
        }
        
        return GeometryReader(content: internalView(geometryProxy:))
            .onReceive(albumViewModel.$allAlbums) { albums in
                allAlbums = albums ?? []
            }
            .onAppear {
                requestAlbums()
            }
            .onDisappear {
                clearAlbum()
            }
    }
    
    func requestAlbums() {
        albumViewModel.requestAlbums(with: albumFetchOptions)
    }
    
    func clearAlbum() {
        albumViewModel.clearAlbum()
    }
}

struct AlbumSelectorGridView_Previews: PreviewProvider {
    static var previews: some View {
        AlbumSelectorGridView()
    }
}

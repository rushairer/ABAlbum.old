//
//  AlbumSelectorGridView.swift
//  ABAlbum
//
//  Created by Abenx on 2021/7/28.
//

import SwiftUI
import Photos

struct AlbumSelectorGridView: View {
    @Environment(\.albumChangeObserver) var albumChangeObserver: AlbumChangeObserver
    @Environment(\.albumFetchOptions) var albumFetchOptions: PHFetchOptions
    
    @State private var allAlbums: [Album] = []
    
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
            
            return ScrollView(.vertical) {
                LazyVGrid(columns: [
                    GridItem(.adaptive(minimum: size.width,
                                       maximum: size.width),
                             spacing: gridSpacing)
                ]) {
                    ForEach(allAlbums, id: \.localIdentifier) { album in
                        NavigationLink(destination: AlbumGridView(album: album)) {
                            if album.assetsResult?.firstObject != nil {
                                AlbumSelectorGridCellView(asset: album.assetsResult!.firstObject!, size: size, thumbnailSize: thumbnailSize, title: album.title, count: album.assetsResult?.count)
                                    .frame(width: size.width, height: size.width)
                            }
                        }
                        .accentColor(Color(uiColor: .label))
                    }
                }
            }
            .overlay(AlbumEmptyView().opacity(allAlbums.count > 0 ? 0 : 1))
            .navigationTitle("Albums")
        }
        
        return GeometryReader(content: internalView(geometryProxy:))
            .onAppear {
                requestAlbums()
            }
            .onReceive(albumChangeObserver.$changeInstance) { changeInstance in
                guard changeInstance != nil else { return }
                refreshAlbums()
            }
            .onDisappear {
                clearAlbum()
            }
    }
    
    func requestAlbums() {
        allAlbums = AlbumService.allAlbums(with: albumFetchOptions)
    }
    
    func refreshAlbums() {
        allAlbums.removeAll()
        requestAlbums()
    }
    
    func clearAlbum() {
        allAlbums.removeAll()
    }
}

struct AlbumSelectorGridView_Previews: PreviewProvider {
    static var previews: some View {
        AlbumSelectorGridView()
    }
}

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
    
    @State private var allAssetCollections: [PHAssetCollection] = []
    
    private let maxColumn: Int = 2
    private let gridSpacing: CGFloat = 8
    
    private var albumEmptyView: some View {
        AlbumEmptyView()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.background)
    }
    
    var body: some View {
        func internalView(geometry: GeometryProxy) -> some View {
            let size = geometry.gridCellSize(number: maxColumn, spacing: gridSpacing)
            let thumbnailSize = size.screenScaledSize()
            
            return ScrollView(.vertical) {
                LazyVGrid(columns: [
                    GridItem(.adaptive(minimum: size.width,
                                       maximum: size.width),
                             spacing: gridSpacing)
                ]) {
                    ForEach(allAssetCollections, id: \.localIdentifier) { album in
                        NavigationLink(destination: AlbumGridView(album: album)) {
                            if album.assetsResult?.firstObject != nil {
                                AlbumSelectorGridCellView(asset: album.assetsResult!.firstObject!, size: size, thumbnailSize: thumbnailSize, title: album.localizedTitle, count: album.assetsResult?.count)
                                    .frame(width: size.width, height: size.width)
                            }
                        }
                        .accentColor(Color(uiColor: .label))
                    }
                }
            }
            .overlay(AlbumEmptyView().opacity(allAssetCollections.count > 0 ? 0 : 1))
            .navigationTitle("Albums")
        }
        
        return GeometryReader(content: internalView(geometry:))
            .onAppear {
                requestAssetCollections()
            }
            .onReceive(albumChangeObserver.$changeInstance) { changeInstance in
                guard changeInstance != nil else { return }
                refreshAssetCollections()
            }
    }
    
    func requestAssetCollections() {
        allAssetCollections = AlbumService.allAssetCollections(with: albumFetchOptions)
    }
    
    func refreshAssetCollections() {
        allAssetCollections = []
        requestAssetCollections()
    }
}

struct AlbumSelectorGridView_Previews: PreviewProvider {
    static var previews: some View {
        AlbumSelectorGridView()
    }
}

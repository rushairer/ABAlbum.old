//
//  AlbumGridView.swift
//  ABAlbum
//
//  Created by Abenx on 2021/7/29.
//

import SwiftUI
import Photos

struct AlbumGridView: View {
    
    @Environment(\.albumViewModel) var albumViewModel: AlbumViewModel
    
    @State private var album: Album?
    @State private var showsPreviwView: Bool = false
    
    private let maxColumn: Int = 4
    private let gridSpacing: CGFloat = 8
    
    var body: some View {
        func internalView(geometryProxy: GeometryProxy) -> some View {
            @CellSize(number: maxColumn, spacing: gridSpacing) var size: CGSize = geometryProxy.size
            @ScreenScaledSize var thumbnailSize:CGSize = size
            
            return ScrollViewReader { scrollViewProxy in
                ZStack(alignment: .topLeading) {
                    NavigationLink(isActive: $showsPreviwView,
                                   destination: {
                        AlbumPreviewView()
                    }) {
                        EmptyView()
                    }
                    ScrollView(.vertical) {
                        LazyVGrid(columns: [
                            GridItem(.adaptive(minimum: size.width, maximum: size.width), spacing: gridSpacing)
                        ]) {
                            if album != nil && album?.assetsResult != nil {
                                ForEach(0..<(album?.assetsResult?.count ?? 0)) { index in
                                    /// 防止循环引用
                                    let localIdentifier: String = album!.assetsResult!.object(at: index).localIdentifier
                                    GeometryReader { proxy in
                                        AlbumGridCellView(asset: album!.assetsResult!.object(at: index),
                                                          size: size,
                                                          thumbnailSize: thumbnailSize,
                                                          requestOptions: ImageFetchOptions.fetchOptions())
                                            .onTapGesture {
                                                albumViewModel.currentAssetLocalIdentifier = localIdentifier
                                                showsPreviwView = true
                                            }
                                    }
                                    .frame(width: size.width, height: size.width)
                                    .id(localIdentifier)
                                }
                            }
                        }
                    }
                    .coordinateSpace(name: "ScrollView")
                }
                .onReceive(albumViewModel.$currentAssetLocalIdentifier) { currentAssetLocalIdentifier in
                    guard let currentAssetLocalIdentifier = currentAssetLocalIdentifier else { return }
                    scrollViewProxy.scrollTo(currentAssetLocalIdentifier)
                }
                .onReceive(albumViewModel.$currentAlbum) { currentAlbum in
                    album = currentAlbum
                }
                .navigationTitle(album?.title ?? "Untitled")
            }
        }
        return GeometryReader(content: internalView(geometryProxy:))
    }
}

struct AlbumGridView_Previews: PreviewProvider {
    static var previews: some View {
        AlbumGridView()
    }
}

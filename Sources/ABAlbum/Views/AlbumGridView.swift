//
//  AlbumGridView.swift
//  ABAlbum
//
//  Created by Abenx on 2021/7/29.
//

import SwiftUI
import Photos

struct AlbumGridView: View {
    
    @State var album: Album
    
    private let maxColumn: Int = 4
    private let gridSpacing: CGFloat = 8
    
    var body: some View {
        func internalView(geometryProxy: GeometryProxy) -> some View {
            @CellSize(number: maxColumn, spacing: gridSpacing) var size: CGSize = geometryProxy.size
            @ScreenScaledSize var thumbnailSize:CGSize = size
            
            return ScrollViewReader { scrollViewProxy in
                ZStack(alignment: .topLeading) {
                    ScrollView(.vertical) {
                        LazyVGrid(columns: [
                            GridItem(.adaptive(minimum: size.width, maximum: size.width), spacing: gridSpacing)
                        ]) {
                            ForEach(0..<(album.assetsResult?.count ?? 0)) { index in
                                GeometryReader { proxy in
                                    NavigationLink(destination: {
                                        AlbumPreviewView(currentAssetLocalIdentifier: album.assetsResult!.object(at: index).localIdentifier,
                                                         album: album) { index in
                                            guard let index = index else { return }
                                            scrollViewProxy.scrollTo(index)
                                        }
                                    }) {
                                        AlbumGridCellView(asset: album.assetsResult!.object(at: index),
                                                          size: size,
                                                          thumbnailSize: thumbnailSize,
                                                          requestOptions: ImageFetchOptions.fetchOptions())
                                    }
                                }
                                .frame(width: size.width, height: size.width)
                                .id(album.assetsResult!.object(at: index).localIdentifier)
                            }
                        }
                    }
                    .coordinateSpace(name: "ScrollView")
                }
                .navigationTitle(album.title)
            }
        }
        return GeometryReader(content: internalView(geometryProxy:))
    }
}

struct AlbumGridView_Previews: PreviewProvider {
    static var previews: some View {
        AlbumGridView(album: Album(assetCollection: PHAssetCollection()))
    }
}

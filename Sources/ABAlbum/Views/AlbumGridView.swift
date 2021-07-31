//
//  AlbumGridView.swift
//  ABAlbum
//
//  Created by Abenx on 2021/7/29.
//

import SwiftUI
import Photos

struct AlbumGridView: View {
    
    @State var album: PHAssetCollection
    
    private let maxColumn: CGFloat = 4
    private let gridSpacing: CGFloat = 8
    
    private func gridWidth(screenSize: CGSize) -> CGFloat {
        return floor((min(screenSize.width, screenSize.height) - gridSpacing * (maxColumn + 1)) / maxColumn)
    }
    
    var body: some View {
        func internalView(geometry: GeometryProxy) -> some View {
            let width = gridWidth(screenSize: geometry.size)
            let scale = Screen.main.scale
            let size = CGSize(width: width, height: width)
            let thumbnailSize = CGSize(width: width * scale, height: width * scale)
            let requestOptions = PHImageRequestOptions()
            requestOptions.deliveryMode = .opportunistic
            requestOptions.isSynchronous = false
            requestOptions.resizeMode = .fast
            requestOptions.isNetworkAccessAllowed = true
            
            return ScrollView(.vertical) {
                LazyVGrid(columns: [
                    GridItem(.adaptive(minimum: width, maximum: width), spacing: gridSpacing)
                ]) {
                    ForEach(0..<(album.assetsResult?.count ?? 0)) { index in
                        NavigationLink(destination: Text(album.assetsResult!.object(at: index).localIdentifier)) {
                            AlbumGridCellView(asset: album.assetsResult!.object(at: index), size: size, thumbnailSize: thumbnailSize, requestOptions: requestOptions)
                                .id(album.assetsResult!.object(at: index).localIdentifier)
                        }
                    }
                }
            }
            .navigationTitle(album.localizedTitle ?? "Untitled")
        }
        
        return GeometryReader(content: internalView(geometry:))
    }
}

struct AlbumGridView_Previews: PreviewProvider {
    static var previews: some View {
        AlbumGridView(album: PHAssetCollection())
    }
}

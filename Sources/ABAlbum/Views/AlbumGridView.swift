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
    private let gridCornerRadius: CGFloat = 8
    
    private func gridWidth(screenSize: CGSize) -> CGFloat {
        return floor((min(screenSize.width, screenSize.height) - gridSpacing * (maxColumn + 1)) / maxColumn)
    }
    
    struct NavigationLinkCell: View {
        var asset: PHAsset
        var size: CGSize
        var thumbnailSize: CGSize
        var requestOptions: PHImageRequestOptions?
        
        var body: some View {
            NavigationLink(destination: Text(asset.localIdentifier)) {
                AlbumGridCellView(asset: asset, size: size, thumbnailSize: thumbnailSize, requestOptions: requestOptions)
                    .id(asset.localIdentifier)
                    .onAppear {
                        DispatchQueue.global(qos: .userInteractive).async {
                            AlbumService.shared.startCachingImages(for: [asset], size: thumbnailSize, requestOptions: requestOptions)
                        }
                    }
                    .onDisappear {
                        DispatchQueue.global(qos: .userInteractive).async {
                            AlbumService.shared.stopCachingImages(for: [asset], size: thumbnailSize, requestOptions: requestOptions)
                        }
                    }
            }
        }
    }
    
    var body: some View {
        func internalView(geometry: GeometryProxy) -> some View {
            let width = gridWidth(screenSize: geometry.size)
            let scale = UIScreen.main.scale
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
                        NavigationLinkCell(asset: album.assetsResult!.object(at: index), size: size, thumbnailSize: thumbnailSize, requestOptions: requestOptions)
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

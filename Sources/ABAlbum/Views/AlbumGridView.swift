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
    
    var filteredAssetsResult: [PHAsset]? {
        return album?.assets
    }
    @State private var assetsCache: [AnyHashable: UIImage?] = [:]

    
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
                            if album?.assets != nil && album!.assets!.count > 0 {
                                ForEach(album!.assets!, id: \.localIdentifier) { asset in
                                    /// 防止循环引用
                                    let localIdentifier: String = asset.localIdentifier
                                    GeometryReader { proxy in
                                        AlbumGridCellView(asset: asset,
                                                          size: size,
                                                          thumbnailSize: thumbnailSize,
                                                          requestOptions: ImageFetchOptions.fetchOptions(),
                                                          assetsCache: $assetsCache)
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
                    withAnimation {
                        album = currentAlbum
                    }
                }
                .onAppear {
                    guard let filteredAssetsResult = filteredAssetsResult else { return }
                    let size = CGSize(width: 10, height: 10)
                    let option = PHImageRequestOptions()
                    option.isNetworkAccessAllowed = true
                    option.isSynchronous = true
                    
                    DispatchQueue.global().async {
                        (PHCachingImageManager.default() as! PHCachingImageManager).startCachingImages(for: filteredAssetsResult, targetSize: size, contentMode: .aspectFill, options: option)
                        filteredAssetsResult.forEach({ asset in
                            (PHCachingImageManager.default() as! PHCachingImageManager).requestImage(for: asset, targetSize: size, contentMode: .aspectFill, options: option) { image, info in
                                assetsCache[asset.localIdentifier] = image
                            }
                        })
                    }
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

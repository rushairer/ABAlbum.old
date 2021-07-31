//
//  AlbumSelectorGridView.swift
//  ABAlbum
//
//  Created by Abenx on 2021/7/28.
//

import SwiftUI
import Photos

struct AlbumSelectorGridView: View {
    
    @State private var allAssetCollections: [PHAssetCollection] = []
    @State private var coordinator: Coordinator?
    
    private let maxColumn: CGFloat = 2
    private let gridSpacing: CGFloat = 8
    
    private func gridWidth(screenSize: CGSize) -> CGFloat {
        return floor((min(screenSize.width, screenSize.height) - gridSpacing * (maxColumn + 1)) / maxColumn)
    }
    
    private var albumEmptyView: some View {
        AlbumEmptyView()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.background)
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
                    GridItem(.adaptive(minimum: width,
                                       maximum: width),
                             spacing: gridSpacing)
                ]) {
                    ForEach(allAssetCollections, id: \.localIdentifier) { album in
                        NavigationLink(destination: AlbumGridView(album: album)) {
                            if album.assetsResult?.firstObject != nil {
                                AlbumSelectorGridCellView(asset: album.assetsResult!.firstObject!, size: size, thumbnailSize: thumbnailSize, title: album.localizedTitle, count: album.assetsResult?.count)
                                    .frame(width: width, height: width)
                            }
                        }
                        .accentColor(Color(uiColor: .label))
                    }
                }
            }
            .overlay(AlbumEmptyView().opacity(allAssetCollections.count > 0 ? 0 : 1))
            .navigationTitle("Albums")
            .onAppear {
                requestAssetCollections()
                registerChangeObserver()
            }
            .onDisappear {
                unregisterChangeObserver()
            }
        }
        
        return GeometryReader(content: internalView(geometry:))
    }
    
    func registerChangeObserver() {
        coordinator = self.makeCoordinator()
        guard coordinator != nil else { return }
        AlbumService.shared.registerChangeObserver(coordinator!)
    }
    
    func unregisterChangeObserver() {
        guard coordinator != nil else { return }
        AlbumService.shared.unregisterChangeObserver(coordinator!)
    }
    
    func requestAssetCollections() {
        allAssetCollections = AlbumService.shared.allAssetCollections
    }
    
    func refreshAssetCollections() {
        allAssetCollections = []
        requestAssetCollections()
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, PHPhotoLibraryChangeObserver {
        var parent: AlbumSelectorGridView
        
        init(_ parentView: AlbumSelectorGridView) {
            parent = parentView
        }
        
        func photoLibraryDidChange(_ changeInstance: PHChange) {
            parent.refreshAssetCollections()
        }
    }
}

struct AlbumSelectorGridView_Previews: PreviewProvider {
    static var previews: some View {
        AlbumSelectorGridView()
    }
}

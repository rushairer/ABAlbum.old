//
//  AlbumSelectorGridView.swift
//  ABAlbum
//
//  Created by Abenx on 2021/7/28.
//

import SwiftUI
import Photos

struct AlbumSelectorGridView: View {
    
    @State var allAssetCollections: [PHAssetCollection] = []
    
    private let maxColumn: CGFloat = 2
    private let gridSpacing: CGFloat = 8
    private let gridCornerRadius: CGFloat = 8
    
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
            
            return ScrollView(.vertical) {
                LazyVGrid(columns: [
                    GridItem(.adaptive(minimum: width,
                                       maximum: width),
                             spacing: gridSpacing)
                ]) {
                    ForEach(allAssetCollections, id: \.localIdentifier) { asset in
                        NavigationLink(destination: AlbumGridView(album: asset)) {
                            AlbumSelectorGridCellView(title: asset.localizedTitle, count: asset.assetsResult?.count)
                                .frame(width: width, height: width)
                        }
                        .accentColor(Color(uiColor: .label))
                    }
                }
                .onAppear {
                    allAssetCollections = AlbumService.shared.allAssetCollections
                }
            }
            .overlay(AlbumEmptyView().opacity(allAssetCollections.count > 0 ? 0 : 1))
            .navigationTitle("Albums")
        }
        
        return GeometryReader(content: internalView(geometry:))
    }
}

struct AlbumSelectorGridView_Previews: PreviewProvider {
    static var previews: some View {
        AlbumSelectorGridView()
    }
}

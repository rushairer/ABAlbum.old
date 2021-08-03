//
//  AlbumPreviewView.swift
//  ABAlbum
//
//  Created by Abenx on 2021/8/1.
//

import SwiftUI
import Photos

struct AlbumPreviewView: View {
    @State var currentAssetLocalIdentifier: String?
    var album: PHAssetCollection
    var onIndexChange: ((String?) -> Void)?
    
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                TabView(selection: $currentAssetLocalIdentifier) {
                    ForEach(0..<(album.assetsResult?.count ?? 0)) { index in
                        AlbumPreviewCellView(asset: album.assetsResult!.object(at: index))
                            .padding(.trailing, 10)
                            .tag(album.assetsResult?.object(at: index).localIdentifier)
                    }
                    .offset(x: 0, y: -proxy.safeAreaInsets.top)
                    .ignoresSafeArea(.all, edges: .all)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .offset(x: 0, y: 0)
            }
            .ignoresSafeArea()
        }
        .onReceive(currentAssetLocalIdentifier.publisher) { index in
            guard onIndexChange != nil else { return }
            onIndexChange!(index)
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct AlbumPreviewView_Previews: PreviewProvider {
    static var previews: some View {
        AlbumPreviewView(album: PHAssetCollection())
    }
}

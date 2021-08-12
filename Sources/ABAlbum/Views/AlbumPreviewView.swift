//
//  AlbumPreviewView.swift
//  ABAlbum
//
//  Created by Abenx on 2021/8/1.
//

import SwiftUI
import Photos
import Combine

struct AlbumPreviewView: View {
    @Environment(\.albumViewModel) var albumViewModel: AlbumViewModel
    
    var album: Album
    
    var toolBar: some View {
        VStack {
            Rectangle()
                .frame(maxWidth: .infinity, maxHeight: 0)
                .background(.bar)
            Spacer()
            HStack {
                Button {
                    
                } label: {
                    Image(systemName: "trash.fill")
                }
                .padding(16)
                
                Spacer()
                
                Button {
                    
                } label: {
                    Image(systemName: "heart")
                }
                .padding(16)
                
                Spacer()
                
                Button {
                    
                } label: {
                    Image(systemName: "square.and.arrow.up.fill")
                }
                .padding(16)
                
                Spacer()
                
                Button {
                    
                } label: {
                    Image(systemName: "rectangle.portrait.and.arrow.right.fill")
                }
                .padding(16)
                
            }
            .font(.title2)
            .padding(.horizontal, 14)
            .background(.bar)
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            .padding(.vertical, 14)
            .padding(.horizontal, 20)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        
                    } label: {
                        Image(systemName: "info.circle.fill")
                    }
                    .padding()
                }
            }
        }
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            GeometryReader { proxy in
                ScrollView(.horizontal, showsIndicators: false) {
                    /// @Environment unlike @StateObject, can not using $albumViewModel.$currentAssetLocalIdentifier.
                    TabView(selection: .init(get: {
                        albumViewModel.currentAssetLocalIdentifier
                    }, set: { id in
                        albumViewModel.currentAssetLocalIdentifier = id
                    })) {
                        ForEach(0..<(album.assetsResult?.count ?? 0)) { index in
                            /// 防止循环引用
                            let localIdentifier = album.assetsResult?.object(at: index).localIdentifier
                            AlbumPreviewCellView(asset: album.assetsResult!.object(at: index))
                                .padding(.trailing, 6)
                                .tag(localIdentifier)
                        }
                    }
                    .frame(width: proxy.size.width, height: proxy.size.height)
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                    .offset(x: 3, y: 0)
                }
            }
            .ignoresSafeArea()
            toolBar
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct AlbumPreviewView_Previews: PreviewProvider {
    static var previews: some View {
        AlbumPreviewView(album: Album(assetCollection: PHAssetCollection()))
    }
}

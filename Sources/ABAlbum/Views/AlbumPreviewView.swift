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
    
    var album: Album
    var onIndexChange: ((String?) -> Void)?
    
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
                    TabView(selection: $currentAssetLocalIdentifier) {
                        ForEach(0..<(album.assetsResult?.count ?? 0)) { index in
                            AlbumPreviewCellView(asset: album.assetsResult!.object(at: index))
                                .padding(.trailing, 6)
                                .tag(album.assetsResult?.object(at: index).localIdentifier)
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
        .onReceive(currentAssetLocalIdentifier.publisher) { index in
            guard onIndexChange != nil else { return }
            onIndexChange!(index)
        }
    }
}

struct AlbumPreviewView_Previews: PreviewProvider {
    static var previews: some View {
        AlbumPreviewView(currentAssetLocalIdentifier: "", album: Album(assetCollection: PHAssetCollection()))
    }
}

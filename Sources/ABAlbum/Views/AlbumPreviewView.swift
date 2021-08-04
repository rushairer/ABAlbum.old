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
        ZStack(alignment: .bottom) {
            GeometryReader { proxy in
                ScrollView(.horizontal, showsIndicators: false) {
                    TabView(selection: $currentAssetLocalIdentifier) {
                        ForEach(0..<(album.assetsResult?.count ?? 0)) { index in
                            AlbumPreviewCellView(asset: album.assetsResult!.object(at: index))
                                .padding(.trailing, 10)
                                .tag(album.assetsResult?.object(at: index).localIdentifier)
                        }
                    }
                    .frame(width: proxy.size.width, height: proxy.size.height)
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                }
            }
            .ignoresSafeArea()

            HStack {
                Button {
                    
                } label: {
                    Image(systemName: "trash.fill")
                }
                .padding(.vertical, 16)
                .padding(.horizontal, 26)
                
                Spacer()
                
                Button {
                    
                } label: {
                    Image(systemName: "heart")
                }
                .padding(.vertical, 16)
                .padding(.horizontal, 26)
                
                Spacer()
                
                Button {
                    
                } label: {
                    Image(systemName: "square.and.arrow.up.fill")
                }
                .padding(.vertical, 16)
                .padding(.horizontal, 26)
                
                Spacer()
                
                Button {
                    
                } label: {
                    Image(systemName: "rectangle.portrait.and.arrow.right.fill")
                }
                .padding(.vertical, 16)
                .padding(.horizontal, 26)
            }
            .font(.title2)
            .background(.thinMaterial)
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
        .navigationBarTitleDisplayMode(.inline)
        .onReceive(currentAssetLocalIdentifier.publisher) { index in
            guard onIndexChange != nil else { return }
            onIndexChange!(index)
        }
    }
}

struct AlbumPreviewView_Previews: PreviewProvider {
    static var previews: some View {
        AlbumPreviewView(album: PHAssetCollection())
    }
}

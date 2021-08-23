//
//  AlbumPreviewView.swift
//  ABAlbum
//
//  Created by Abenx on 2021/8/1.
//

import SwiftUI
import Photos

struct AlbumPreviewView: View {
    @Environment(\.albumViewModel) var albumViewModel: AlbumViewModel
    
    @State private var album: Album?
    
    var toolBar: some View {
        VStack {
            Rectangle()
                .frame(maxWidth: .infinity, maxHeight: 0)
                .background(.bar)
            Spacer()
            HStack {
                Button {
                    deleteButtonOnClicked()
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
                    NotificationCenter.default.post(name: ABAlbum.actionButtonDidClickedNotification, object: albumViewModel.currentAssetLocalIdentifier)
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
                    if album?.assets != nil && album!.assets!.count > 0 {
                        let localIdentifier = album?.localIdentifier
                        /// @Environment unlike @StateObject, can not using $albumViewModel.$currentAssetLocalIdentifier.
                        TabView(selection: .init(get: {
                            albumViewModel.currentAssetLocalIdentifier
                        }, set: { id in
                            albumViewModel.currentAssetLocalIdentifier = id
                        })) {
                            
                            ForEach(album!.assets!, id: \.localIdentifier) { asset in
                                /// 防止循环引用
                                let localIdentifier = asset.localIdentifier
                                AlbumPreviewCellView(asset: asset)
                                    .padding(.trailing, 6)
                                    .tag(localIdentifier)
                            }
                        }
                        .frame(width: proxy.size.width, height: proxy.size.height)
                        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                        .offset(x: 3, y: 0)
                        .id(localIdentifier)
                    }
                }
                .onReceive(albumViewModel.$currentAlbum) { currentAlbum in
                    withAnimation {
                        album = currentAlbum
                    }
                }
            }
            .ignoresSafeArea()
            toolBar
        }
        .navigationBarTitleDisplayMode(.inline)
    }
    
    func deleteButtonOnClicked() {
        guard let selectedAssetLocalIdentifier = albumViewModel.currentAssetLocalIdentifier else { return }
        let asset = PHAsset.fetchAssets(withLocalIdentifiers: [selectedAssetLocalIdentifier], options: nil).firstObject
        guard let asset = asset else { return }
        
        do {
            try PHPhotoLibrary.shared().performChangesAndWait {
                PHAssetChangeRequest.deleteAssets([asset] as NSFastEnumeration)
            }
        }
        catch (let error) {
            print(error)
        }
    }
}

struct AlbumPreviewView_Previews: PreviewProvider {
    static var previews: some View {
        AlbumPreviewView()
    }
}

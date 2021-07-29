//
//  AlbumGridCellView.swift
//  ABAlbum
//
//  Created by Abenx on 2021/7/29.
//

import SwiftUI
import Photos

struct AlbumGridCellView: View {
    
    var asset: PHAsset
    var size: CGSize
    var thumbnailSize: CGSize
    var requestOptions: PHImageRequestOptions?
    
    @State private var thumbnailImage: UIImage?
    
    var body: some View {
        ZStack {
            Image(uiImage: thumbnailImage ?? UIImage())
                .resizable()
                .scaledToFill()
                .frame(width: size.width, height: size.height)
                .clipped()
                .overlay(ProgressView().frame(width: size.width, height: size.height).background(Color(uiColor: .tertiarySystemGroupedBackground)).opacity(thumbnailImage == nil ? 1 : 0))
        }
        .onAppear {
            guard thumbnailImage == nil else { return }
            Task(priority: .high) {
                do {
                    for try await image in AlbumService.shared.asyncImage(from: asset, size: thumbnailSize, requestOptions: requestOptions) {
                        thumbnailImage = image
                    }
                } catch let error {
                    thumbnailImage = nil
                    print(error)
                }
            }
        }
    }
}

struct AlbumGridCellView_Previews: PreviewProvider {
    static var previews: some View {
        AlbumGridCellView(asset: PHAsset(), size: CGSize.zero, thumbnailSize: CGSize.zero)
    }
}

//
//  AlbumPreviewCellView.swift
//  ABAlbum
//
//  Created by Abenx on 2021/8/1.
//

import SwiftUI
import Photos
import ZoomableImageView

struct AlbumPreviewCellView: View {
    var asset: PHAsset
    
    @State private var scale: CGFloat = 1.0
    @State private var lastScaleValue: CGFloat = 1.0
    
    
    @State private var previewImage: UIImage =  UIImage()
    
#if DEBUG
    @State private var errorMsg: String?
#endif

    var body: some View {
        GeometryReader { proxy in
            ZStack {
                if previewImage != UIImage() {
                    ZoomableImageView(image: previewImage)
                        .frame(width: proxy.size.width, height: proxy.size.height)
                } else {
                    ProgressView()
                }
            }
            .navigationTitle(asset.creationDate?.stringValue ?? "")
            .task {
                guard previewImage == UIImage() else { return }
                
                let requestOptions = PHImageRequestOptions()
                requestOptions.deliveryMode = .opportunistic
                requestOptions.isSynchronous = false
                requestOptions.resizeMode = .fast
                requestOptions.isNetworkAccessAllowed = true
                
                async let stream = AlbumService.shared.asyncImage(from: asset, size: ImageSize.large.size, requestOptions: requestOptions)
                do {
                    for try await image in await stream {
                        previewImage = image
                    }
                } catch let error {
                    previewImage = UIImage(named: "photo_demo", in: .module, with: nil) ?? UIImage()
                    print(error)
#if DEBUG
                    errorMsg = error.localizedDescription
#endif
                }
            }
        }
    }
}

struct AlbumPreviewCellView_Previews: PreviewProvider {
    static var previews: some View {
        AlbumPreviewCellView(asset: PHAsset())
    }
}

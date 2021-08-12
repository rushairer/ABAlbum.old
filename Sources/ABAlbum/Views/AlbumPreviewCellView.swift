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
    
    @State private var previewImage: UIImage =  UIImage()
    
    @DateFormatDate private var dateValue: Date?
    @TimeFormatDate private var timeValue: Date?
    
    init(asset: PHAsset) {
        self.asset = asset
        dateValue = asset.creationDate
        timeValue = asset.creationDate
    }

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
            .toolbar {
                ToolbarItem(placement: .principal) {
                    VStack {
                        Text($dateValue)
                        Text($timeValue).font(.caption)
                    }
                }
            }
            .task {
                //guard previewImage == UIImage() else { return }
                
                async let stream = AlbumService.asyncImage(from: asset, size: ImageSize.large.size, requestOptions: ImageFetchOptions.fetchOptions())
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
            .onDisappear {
                // previewImage = UIImage()
            }
        }
    }
}

struct AlbumPreviewCellView_Previews: PreviewProvider {
    static var previews: some View {
        AlbumPreviewCellView(asset: PHAsset())
    }
}

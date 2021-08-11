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
    
    @DefaultImageRequestOptions private var defaultImageRequestOptions: PHImageRequestOptions

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
            //.navigationTitle(asset.creationDate?.stringValue ?? "")
            .toolbar {
                ToolbarItem(placement: .principal) {
                    VStack {
                        Text($dateValue)
                        Text($timeValue).font(.caption)
                    }
                }
            }
            .task {
                // fix: 去掉缓存判断，每次加载cell时候都要重新请求图片。
                // 如果保留以下代码，点击非第一张进入TabView的时候，会默认给第一个cell渲染，然后跳转到点击的cell。这样的结果会导致第一个cell只得到缩略图。
                // guard previewImage == UIImage() else { return }
                
                async let stream = AlbumService.asyncImage(from: asset, size: ImageSize.large.size, requestOptions: defaultImageRequestOptions)
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
                // 点击非第一个cell时，第一个cell会渲染，然后跳转到点击cell，并没有触发onDisappear。
                previewImage = UIImage()
            }
        }
    }
}

struct AlbumPreviewCellView_Previews: PreviewProvider {
    static var previews: some View {
        AlbumPreviewCellView(asset: PHAsset())
    }
}

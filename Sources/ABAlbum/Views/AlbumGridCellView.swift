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
    @Binding var assetsCache: [AnyHashable: UIImage?]

    @State private var thumbnailImage: UIImage?
    
#if DEBUG
    @State private var errorMsg: String?
#endif
    
    /*
    init(asset: PHAsset, size: CGSize, thumbnailSize: CGSize, requestOptions: PHImageRequestOptions? = nil) {
        self.asset = asset
        self.size = size
        self.thumbnailSize = thumbnailSize
        self.requestOptions = requestOptions
        
        AlbumService.startCachingImages(for: [asset], size: thumbnailSize, requestOptions: requestOptions)
        
        defer {
            AlbumService.stopCachingImages(for: [asset], size: thumbnailSize, requestOptions: requestOptions)
        }
    }
     */

    var body: some View {
        ZStack {
            //Image(uiImage: thumbnailImage ?? UIImage())
            Image(uiImage: (thumbnailImage ?? (assetsCache[asset.localIdentifier] ?? UIImage()))!)

                .resizable()
                .scaledToFill()
                .frame(width: size.width, height: size.height)
                .clipped()
//                .overlay(ProgressView().frame(width: size.width, height: size.height).background(Color(uiColor: .tertiarySystemGroupedBackground)).opacity(thumbnailImage == nil ? 1 : 0))
#if DEBUG
            if errorMsg != nil {
                Text("ERROR")
                    .font(.largeTitle)
                    .fontWeight(.ultraLight)
                    .blendMode(.overlay)
                    .padding(.vertical, 6)
                    .padding(.horizontal, 24)
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 4, style: .continuous))
            }
#endif
        }
        .task {
            guard thumbnailImage == nil else { return }
            async let stream = AlbumService.asyncImage(from: asset, size: thumbnailSize, requestOptions: requestOptions)
            do {
                for try await image in await stream {
                    thumbnailImage = image
                }
            } catch let error {
                thumbnailImage = UIImage(named: "photo_demo", in: .module, with: nil)
                print(error)
#if DEBUG
                errorMsg = error.localizedDescription
#endif
            }
        }
    }
    
    struct ShowsNoPermissionView: ViewModifier {
        
        func body(content: Content) -> some View {
            content.overlay(Color.red)
        }
    }
    
    fileprivate func showsDemoThumbnailImage() -> some View {
        //thumbnailImage = UIImage(named: "photo_demo", in: .module, with: nil)
        
        return self.modifier(ShowsNoPermissionView())
    }
}

struct AlbumGridCellView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            AlbumGridCellView(asset: PHAsset(), size: CGSize(width: 200, height: 200), thumbnailSize: CGSize.zero, assetsCache: .constant([:]))
                .preferredColorScheme(.dark)
                .previewLayout(.sizeThatFits)
                .frame(width: 200, height: 200)
            AlbumGridCellView(asset: PHAsset(), size: CGSize(width: 200, height: 200), thumbnailSize: CGSize.zero, assetsCache: .constant([:]))
                .previewLayout(.sizeThatFits)
                .frame(width: 200, height: 200)
        }
    }
}

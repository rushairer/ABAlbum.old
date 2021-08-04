//
//  AlbumSelectorGridCellView.swift
//  ABAlbum
//
//  Created by Abenx on 2021/7/29.
//

import SwiftUI
import Photos

struct AlbumSelectorGridCellView: View {
    
    var asset: PHAsset
    var size: CGSize
    var thumbnailSize: CGSize
    var requestOptions: PHImageRequestOptions?
    var title: String?
    var count: Int?
    
    @State private var thumbnailImage: UIImage?
    
#if DEBUG
    @State private var errorMsg: String?
#endif
    
    @ViewBuilder
    var image: some View {
        if thumbnailImage == nil {
            Image("photo_demo", bundle: .module)
        } else {
            Image(uiImage: thumbnailImage!)
        }
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Image(uiImage: thumbnailImage ?? UIImage())
                .resizable()
                .scaledToFill()
                .frame(width: size.width, height: size.height)
                .clipped()
                .overlay(
                    ProgressView()
                        .frame(width: size.width, height: size.height)
                        .background(Color(uiColor: .tertiarySystemGroupedBackground))
                        .opacity(thumbnailImage == nil ? 1 : 0)
                )
            HStack {
                Text(title ?? "Untitled")
                Spacer()
                Text("\(count ?? 0)").font(.footnote).foregroundColor(.secondary)
            }
            .blendMode(.overlay)
            .padding(10)
            .background(.ultraThinMaterial)
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
                    .frame(maxWidth:.infinity, maxHeight: .infinity)
            }
#endif
        }
        .task {
            guard thumbnailImage == nil else { return }
            async let stream = AlbumService.shared.asyncImage(from: asset, size: thumbnailSize, requestOptions: requestOptions)
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
}

struct AlbumSelectorGridCellView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            AlbumSelectorGridCellView(asset: PHAsset(), size: CGSize(width: 200, height: 200), thumbnailSize: CGSize.zero)
                .preferredColorScheme(.dark)
                .previewLayout(.sizeThatFits)
                .frame(width: 200.0, height: 200.0)
            AlbumSelectorGridCellView(asset: PHAsset(), size: CGSize(width: 200, height: 200), thumbnailSize: CGSize.zero)
                .preferredColorScheme(.light)
                .previewLayout(.sizeThatFits)
                .frame(width: 200.0, height: 200.0)
        }
    }
}

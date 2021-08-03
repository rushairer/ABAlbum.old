//
//  AlbumGridView.swift
//  ABAlbum
//
//  Created by Abenx on 2021/7/29.
//

import SwiftUI
import Photos

struct AlbumGridView: View {
    
    @State var album: PHAssetCollection
    
    private let maxColumn: CGFloat = 4
    private let gridSpacing: CGFloat = 8
    
    /// 点击时跳转
    @State private var currentAssetLocalIdentifier: String?
    
    /// 激活图片所在区域
    @State private var currentAssetReact: CGRect = .zero
    
    /// 激活图片遮挡
    @State private var currentAssetMaskReact: CGRect = .zero
    
    /// 激活图片缩略图透明度
    @State private var currentAssetOpacity: Double = 0
    
    /// 激活图片遮挡透明度
    @State private var currentAssetMaskOpacity: Double = 0
    
    /// 激活图片的索引(localIdentifier)
    @State private var currentAssetIndex: String?
    
    /// 屏幕中 cells 的位置信息
    @State private var cellFramePreferences: [CellFramePreference] = []
    
    @State private var thumbnailImage: UIImage?
    
    private func gridWidth(screenSize: CGSize) -> CGFloat {
        return floor((min(screenSize.width, screenSize.height) - gridSpacing * (maxColumn + 1)) / maxColumn)
    }
    
    @MainActor
    private func updateThumbnailImage(image: UIImage) {
        thumbnailImage = image
    }
    
    var body: some View {
        func internalView(geometry: GeometryProxy) -> some View {
            let width = gridWidth(screenSize: geometry.size)
            let scale = Screen.main.scale
            let size = CGSize(width: width, height: width)
            let thumbnailSize = CGSize(width: width * scale, height: width * scale)
            let requestOptions = PHImageRequestOptions()
            requestOptions.deliveryMode = .opportunistic
            requestOptions.isSynchronous = false
            requestOptions.resizeMode = .fast
            requestOptions.isNetworkAccessAllowed = true
            
            return ScrollViewReader { scrollViewProxy in
                ZStack(alignment: .topLeading) {
                    ScrollView(.vertical) {
                        LazyVGrid(columns: [
                            GridItem(.adaptive(minimum: width, maximum: width), spacing: gridSpacing)
                        ]) {
                            ForEach(0..<(album.assetsResult?.count ?? 0)) { index in
                                GeometryReader { proxy in
                                    NavigationLink(tag: album.assetsResult!.object(at: index).localIdentifier,
                                                   selection: $currentAssetLocalIdentifier,
                                                   destination: {
                                        AlbumPreviewView(currentAssetLocalIdentifier: currentAssetLocalIdentifier,
                                                         album: album) { index in
                                            guard let index = index else { return }
                                            scrollViewProxy.scrollTo(index)
                                            currentAssetIndex = index
                                        }
                                    }) {
                                        AlbumGridCellView(asset: album.assetsResult!.object(at: index),
                                                          size: size,
                                                          thumbnailSize: thumbnailSize,
                                                          requestOptions: requestOptions)
                                            .onTapGesture {
                                                currentAssetLocalIdentifier = album.assetsResult!.object(at: index).localIdentifier
                                            }
                                            .preference(key: CellFramePreferenceKey.self,
                                                        value: [
                                                            CellFramePreference(localIdentifier: album.assetsResult!.object(at: index).localIdentifier,
                                                                                frame: proxy.frame(in: .named(index)))
                                                        ])
                                    }
                                }
                                .frame(width: width, height: width)
                                .id(album.assetsResult!.object(at: index).localIdentifier)
                            }
                        }
                    }
                    Color
                        .clear
                        .background(Image(uiImage: thumbnailImage ?? UIImage()).resizable().scaledToFill())
                        .offset(x: currentAssetReact.origin.x,
                                y: currentAssetReact.origin.y - geometry.safeAreaInsets.top)
                        .frame(width: currentAssetReact.width,
                               height: currentAssetReact.height)
                        .opacity(currentAssetOpacity)
                    
                    Color(uiColor: .systemBackground)
                        .offset(x: currentAssetMaskReact.origin.x,
                                y: currentAssetMaskReact.origin.y - geometry.safeAreaInsets.top)
                        .frame(width: currentAssetMaskReact.width,
                               height: currentAssetMaskReact.height)
                        .opacity(currentAssetMaskOpacity)
                }
                .onPreferenceChange(CellFramePreferenceKey.self, perform: { preferences in
                    cellFramePreferences = preferences
                })
                .onAppear {
                    let preference = cellFramePreferences.first(where: { $0.localIdentifier == currentAssetIndex })
                    guard preference != nil && preference?.frame != nil && currentAssetIndex != nil else { return }
                    
                    /// 加载缩略图
                    Task {
                        let assetResult: PHFetchResult<PHAsset> = PHAsset.fetchAssets(withLocalIdentifiers: [currentAssetIndex!],
                                                                                      options: nil)
                        if assetResult.count > 0 {
                            async let stream = AlbumService.shared.asyncImage(from: assetResult.firstObject!,
                                                                              size: geometry.size,
                                                                              requestOptions: nil)
                            do {
                                for try await image in await stream {
                                    await updateThumbnailImage(image: image)
                                }
                            } catch let error {
                                print(error)
                            }
                        }
                    }
                    
                    /// 遮挡色块移动到 cell 上方
                    currentAssetMaskReact = preference!.frame
                    
                    /// 缩略图缩放到 cell 位置
                    withAnimation {
                        currentAssetReact = preference!.frame
                    }
                    
                    /// 缩略图变透明
                    withAnimation(.easeOut(duration: 0.4)) {
                        currentAssetOpacity = 0
                    }
                    
                    /// 遮挡色块变透明
                    withAnimation(.linear(duration: 0.2).delay(0.2)) {
                        currentAssetMaskOpacity = 0
                    }
                }
                .onDisappear {
                    currentAssetReact = geometry.frame(in: .global)
                    currentAssetReact.origin.x = currentAssetReact.size.width
                    currentAssetOpacity = 1
                    currentAssetMaskOpacity = 1
                    thumbnailImage = nil
                }
                .navigationTitle(album.localizedTitle ?? "Untitled")
                .coordinateSpace(name: "AlbumGridViewSpace")
            }
        }
        return GeometryReader(content: internalView(geometry:))
    }
}

struct CellFramePreference: Equatable {
    let localIdentifier: String
    let frame: CGRect
}

struct CellFramePreferenceKey: PreferenceKey {
    typealias Value = [CellFramePreference]
    static var defaultValue: [CellFramePreference] = []
    static func reduce(value: inout [CellFramePreference], nextValue: () -> [CellFramePreference]) {
        value.append(contentsOf: nextValue())
    }
}

struct AlbumGridView_Previews: PreviewProvider {
    static var previews: some View {
        AlbumGridView(album: PHAssetCollection())
    }
}

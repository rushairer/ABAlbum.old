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
    
    /// 显示遮挡
    @State private var showsMask: Bool = false
    
    /// 缩略图透明度
    @State private var thumbnailOpacity: Double = 1
    
    /// 点击时跳转
    @State private var currentAssetLocalIdentifier: String? {
        didSet {
            print(currentAssetLocalIdentifier)
        }
    }
    
    /// 激活图片所在区域
    @State private var thumbnailReact: CGRect = .zero
    /// 激活图片遮挡
    @State private var maskReact: CGRect = .zero
    
    /// 激活图片的索引(localIdentifier)
    @State private var thumbnailIdentifier: String?
    
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
                                        AlbumPreviewView(currentAssetLocalIdentifier: $currentAssetLocalIdentifier,
                                                         album: album) { index in
                                            guard let index = index else { return }
                                            scrollViewProxy.scrollTo(index)
                                            thumbnailIdentifier = index
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
                                                                                frame: proxy.frame(in: .named("ScrollView")))
                                                        ])
                                    }
                                }
                                .frame(width: width, height: width)
                                .id(album.assetsResult!.object(at: index).localIdentifier)
                            }
                        }
                    }
                    .coordinateSpace(name: "ScrollView")
                    
                    if showsMask {
                        Color(uiColor: .systemBackground)
                            .offset(x: maskReact.origin.x,
                                    y: maskReact.origin.y)
                            .frame(width: maskReact.width,
                                   height: maskReact.height)
                            .transition(
                                .maskTransition
                                    .animation(.linear(duration: 0.2).delay(0.2))
                            )
                    }
                    
                    Image(uiImage: thumbnailImage ?? UIImage()).resizable().scaledToFill()
                        .offset(x: thumbnailReact.origin.x,
                                y: thumbnailReact.origin.y)
                        .frame(width: thumbnailReact.width,
                               height: thumbnailReact.height)
                        .opacity(thumbnailOpacity)
                    
                }
                .onPreferenceChange(CellFramePreferenceKey.self, perform: { preferences in
                    cellFramePreferences = preferences
                })
                .onAppear {
                    let preference = cellFramePreferences.first(where: { $0.localIdentifier == thumbnailIdentifier })
                    guard preference != nil && preference?.frame != nil && thumbnailIdentifier != nil else { return }
                    
                    /// 加载缩略图
                    Task {
                        let assetResult: PHFetchResult<PHAsset> = PHAsset.fetchAssets(withLocalIdentifiers: [thumbnailIdentifier!],
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
                    /// 遮挡色块 & 缩略图缩, 移动到 cell 上方
                    maskReact  = preference!.frame
                    showsMask = true
                    
                    /// 缩略图缩, 移动到 cell 上方
                    withAnimation(.easeInOut(duration: 0.4)) {
                        thumbnailOpacity = 0
                        thumbnailReact = preference!.frame
                    }
                }
                .onDisappear {
                    showsMask = false
                    thumbnailOpacity = 1
                    maskReact = .zero
                    
                    thumbnailReact = geometry.frame(in: .global)
                    thumbnailReact.origin.x = thumbnailReact.size.width
                    thumbnailImage = nil
                }
                .navigationTitle(album.localizedTitle ?? "Untitled")
            }
        }
        return GeometryReader(content: internalView(geometry:))
    }
}

extension AnyTransition {
    static var maskTransition: AnyTransition {
        get {
            AnyTransition.modifier(
                active: OpacityModifier(opacity: 1),
                identity: OpacityModifier(opacity: 0)
            )
        }
    }
}
struct OpacityModifier: ViewModifier {
    let opacity: Double
    func body(content: Content) -> some View {
        content.opacity(opacity)
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

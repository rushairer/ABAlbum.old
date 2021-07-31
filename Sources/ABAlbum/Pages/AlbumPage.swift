//
//  AlbumPage.swift
//  ABAlbum
//
//  Created by Abenx on 2021/7/27.
//

import SwiftUI
import Photos

public struct AlbumPage: View {
    
    public init() {}
    
    public var body: some View {
        AlbumSelectorGridView()
    }
    
    public func showsNoPermissionView(_ showsAlbumNoPermissionView: Binding<Bool>) -> some View {
        self.modifier(ShowsNoPermissionView(showsAlbumNoPermissionView: showsAlbumNoPermissionView))
    }
    
    struct ShowsNoPermissionView: ViewModifier {
        @Binding var showsAlbumNoPermissionView: Bool
        
        func body(content: Content) -> some View {
            if showsAlbumNoPermissionView {
                content
                    .overlay(
                        AlbumNoPermissionView()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(.background)
                    )
            } else {
                content
            }
        }
    }
}

struct AlbumPage_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            AlbumPage()
            AlbumPage().showsNoPermissionView(.constant(true))
        }
    }
}

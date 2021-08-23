//
//  AlbumPage.swift
//  ABAlbum
//
//  Created by Abenx on 2021/7/27.
//

import SwiftUI
import Photos

/// The base page for Album.
///
/// You need request PHAuthorizationStatus first, and decide whether to display NoPermissionView using a Boolen binding.
///
/// ```swift
///
///  @State var showsAlbumNoPermissionView: Bool = AlbumAuthorizationStatus.isNotDetermined
///
///  var body: some View {
///     AlbumPage()
///         .showsNoPermissionView($showsAlbumNoPermissionView)
///         .albumFetchOptions(.fetchOptions(with: mediaType))
///         .task {
///             showsAlbumNoPermissionView = await !AlbumAuthorizationStatus.hasAlbumPermission
///         }
///  }
///
/// ```
public struct AlbumPage: View {
    
    /// Shows album has no permission view or not.
    @Binding public var showsAlbumNoPermissionView: Bool
    
    public init(showsAlbumNoPermissionView: Binding<Bool>) {
        _showsAlbumNoPermissionView = showsAlbumNoPermissionView
    }
    
    public var body: some View {
        /// First run the application, need refresh views when permission changed.
        /// So we need if...else.
        if showsAlbumNoPermissionView {
            AlbumNoPermissionView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.background)
        } else {
            AlbumSelectorGridView()
        }
    }
}

struct AlbumPage_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            AlbumPage(showsAlbumNoPermissionView: .constant(true))
            AlbumPage(showsAlbumNoPermissionView: .constant(false))
        }
    }
}

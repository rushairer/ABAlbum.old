//
//  AlbumPreviewView.swift
//  ABAlbum
//
//  Created by Abenx on 2021/8/1.
//

import SwiftUI
import Photos
import PhotosUI

struct AlbumPreviewView: View {
    
    var asset: PHAsset
    
    var body: some View {
        GeometryReader { proxy in
           AlbumPreviewCellView(asset: asset)
        }
        .ignoresSafeArea()
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct AlbumPreviewView_Previews: PreviewProvider {
    static var previews: some View {
        AlbumPreviewView(asset: PHAsset())
    }
}

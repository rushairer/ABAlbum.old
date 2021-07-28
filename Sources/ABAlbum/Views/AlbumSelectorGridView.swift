//
//  AlbumSelectorGridView.swift
//  AlbumSelectorGridView
//
//  Created by Abenx on 2021/7/28.
//

import SwiftUI

struct AlbumSelectorGridView: View {
    
    private var albumEmptyView: some View {
        AlbumEmptyView()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.background)
    }
    
    var body: some View {
        GeometryReader { geometry in
            albumEmptyView
        }
    }
}

struct AlbumSelectorGridView_Previews: PreviewProvider {
    static var previews: some View {
        AlbumSelectorGridView()
    }
}

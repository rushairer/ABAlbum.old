//
//  AlbumSelectorGridCellView.swift
//  ABAlbum
//
//  Created by Abenx on 2021/7/29.
//

import SwiftUI

struct AlbumSelectorGridCellView: View {
    var image: Image?
    var title: String?
    var count: Int?
    
    var body: some View {
        VStack(alignment: .leading) {
            Spacer()
            HStack {
                Text(title ?? "Untitled")
                Spacer()
                Text("\(count ?? 0)").font(.footnote).foregroundColor(.secondary)
            }
            .padding(10)
            .background(.thinMaterial)
        }
        .background(
            image ?? Image("photo_demo", bundle: .module)
        )
        .clipped()
    }
}

struct AlbumSelectorGridCellView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            AlbumSelectorGridCellView()
                .preferredColorScheme(.dark)
                .previewLayout(.sizeThatFits)
                .frame(width: 200.0, height: 200.0)
            AlbumSelectorGridCellView()
                .preferredColorScheme(.light)
                .previewLayout(.sizeThatFits)
                .frame(width: 200.0, height: 200.0)
        }
    }
}

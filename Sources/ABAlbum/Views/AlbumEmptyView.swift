//
//  AlbumEmptyView.swift
//  ABAlbum
//
//  Created by Abenx on 2021/7/27.
//

import SwiftUI

struct AlbumEmptyView: View {    
    var body: some View {
        VStack(spacing: 30) {
            Image(systemName: "photo.fill.on.rectangle.fill")
                .resizable()
                .symbolRenderingMode(.hierarchical)
                .foregroundColor(.accentColor)
                .font(.body.weight(.thin))
                .aspectRatio(contentMode: .fit)
                .frame(width: 80, height: 80, alignment: .center)
            Text("No Photos")
                .font(.headline)
            Text("You can take photos using the camera.")
                .font(.subheadline)
                .multilineTextAlignment(.center)
        }
    }
}

struct AlbumEmptyView_Previews: PreviewProvider {
    static var previews: some View {
        AlbumEmptyView()
    }
}

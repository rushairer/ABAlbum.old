//
//  AlbumEmptyView.swift
//  AlbumEmptyView
//
//  Created by Abenx on 2021/7/27.
//

import SwiftUI

struct AlbumEmptyView: View {
    @Environment(\.dismiss) var dismiss
    
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
            Button("Go back", action: dismiss.callAsFunction)
                .buttonStyle(.bordered)
                .tint(.accentColor)
                .controlSize(.small)
        }
    }
}

struct AlbumEmptyView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            AlbumEmptyView()
            AlbumEmptyView()
                .previewInterfaceOrientation(.landscapeRight)
            AlbumEmptyView()
                .preferredColorScheme(.dark)
                .accentColor(.pink)
            AlbumEmptyView()
                .previewDevice("iPad mini (5th generation)")
            NavigationView {
                NavigationLink(destination: AlbumEmptyView(), label: {
                    Text("Open AlbumEmptyView")
                })
            }
        }
    }
}

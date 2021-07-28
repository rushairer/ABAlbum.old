//
//  AlbumNoPermissionView.swift
//  AlbumNoPermissionView
//
//  Created by Abenx on 2021/7/28.
//

import SwiftUI

struct AlbumNoPermissionView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.openURL) var openURL
    
    private var appName: String {
        Bundle.main.object(forInfoDictionaryKey: kCFBundleNameKey as String) as? String ?? "your app"
    }
    
    var body: some View {
        VStack(spacing: 30) {
            Image(systemName: "eye.trianglebadge.exclamationmark.fill")
                .resizable()
                .symbolRenderingMode(.hierarchical)
                .foregroundColor(.accentColor)
                .font(.body.weight(.thin))
                .aspectRatio(contentMode: .fit)
                .frame(width: 80, height: 80, alignment: .center)
            Text("No access to photos. Go to system setting and allow \(appName) to access all photos in album.")
                .font(.subheadline)
                .multilineTextAlignment(.center)
            VStack(spacing: 20) {
                Button("Go to system settings") {
                    guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
                    openURL(url)
                }
                .buttonStyle(.borderedProminent)
                Button("Go back", action: dismiss.callAsFunction)
                    .buttonStyle(.bordered)
            }
            .tint(.accentColor)
            .controlSize(.small)
        }
    }
}

struct AlbumNoPermissionView_Previews: PreviewProvider {
    static var previews: some View {
        AlbumNoPermissionView()
    }
}

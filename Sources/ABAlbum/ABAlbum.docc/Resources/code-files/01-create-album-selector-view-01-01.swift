import SwiftUI

struct AlbumSelectorGridCellView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Spacer()
            HStack {
                Text("Untitled")
                Spacer()
                Text("0").font(.footnote).foregroundColor(.secondary)
            }
        }
        .background(
            Image("photo_demo", bundle: .module)
        )
    }
}

struct AlbumSelectorGridCellView_Previews: PreviewProvider {
    static var previews: some View {
        AlbumSelectorGridCellView()
    }
}

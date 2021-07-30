import SwiftUI

struct AlbumSelectorGridView: View {
    
    private let maxColumn: CGFloat = 2
    private let gridSpacing: CGFloat = 8
    private let gridCornerRadius: CGFloat = 8
    
    private func gridWidth() -> CGFloat {
        let screenSize = UIScreen.main.bounds.size
        return floor((min(screenSize.width, screenSize.height) - gridSpacing * (maxColumn + 1)) / maxColumn)
    }
    
    var body: some View {
        ScrollView(.vertical) {
            LazyVGrid(columns: [
                GridItem(.adaptive(minimum: gridWidth(), maximum: gridWidth()), spacing: gridSpacing)
            ]) {
                ForEach(0..<100) { index in
                    AlbumSelectorGridCellView()
                        .frame(width: gridWidth(), height: gridWidth())
                }
            }
        }
    }
}

struct AlbumSelectorGridView_Previews: PreviewProvider {
    static var previews: some View {
        AlbumSelectorGridView()
    }
}

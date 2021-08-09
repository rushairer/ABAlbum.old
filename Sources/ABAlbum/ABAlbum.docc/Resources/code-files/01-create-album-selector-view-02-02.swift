import SwiftUI

struct AlbumSelectorGridView: View {
    
    private let maxColumn: CGFloat = 2
    private let gridSpacing: CGFloat = 8
    private let gridCornerRadius: CGFloat = 8
    
    private func gridWidth(screenSize: CGSize) -> CGFloat {
        return floor((min(screenSize.width, screenSize.height) - gridSpacing * (maxColumn + 1)) / maxColumn)
    }
    
    var body: some View {
        func internalView(geometryProxy: GeometryProxy) -> some View {
            let width = gridWidth(screenSize: geometryProxy.size)

            return ScrollView(.vertical) {
                LazyVGrid(columns: [
                    GridItem(.adaptive(minimum: width, maximum: width), spacing: gridSpacing)
                ]) {
                    ForEach(0..<100) { index in
                        AlbumSelectorGridCellView()
                            .frame(width: width, height: width)
                    }
                }
            }
        }
        return GeometryReader(content: internalView(geometryProxy:))
    }
}

struct AlbumSelectorGridView_Previews: PreviewProvider {
    static var previews: some View {
        AlbumSelectorGridView()
    }
}

//
//  File.swift
//  File
//
//  Created by Abenx on 2021/8/9.
//

import SwiftUI

extension GeometryProxy {
    func gridCellSize(number: Int, spacing: CGFloat = 0) -> CGSize {
        let width = floor((min(self.size.width, self.size.height) - spacing * (CGFloat(number) + 1)) / CGFloat(number))
        return CGSize(width: width, height: width)
    }
}

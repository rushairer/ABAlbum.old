//
//  File.swift
//  File
//
//  Created by Abenx on 2021/8/9.
//

import UIKit

extension CGSize {
    func screenScaledSize() -> CGSize {
        let scale = UIScreen.main.scale
        return CGSize(width: self.width * scale, height: self.height * scale)
    }
}

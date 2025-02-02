//
//  Color+.swift
//  DSComponents
//

import Foundation
import SwiftUICore
import UIKit.UIColor

// MARK: - [Extension] Color

extension Color {

    // MARK: Variables

    var isClear: Bool {
        let uiColor = UIColor(self)
        var alpha: CGFloat = 0
        uiColor.getRed(nil, green: nil, blue: nil, alpha: &alpha)
        return alpha == 0
    }

}

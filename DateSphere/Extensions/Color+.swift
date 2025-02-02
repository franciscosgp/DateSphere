//
//  Color+.swift
//  DateSphere
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

    // MARK: Initializers

    init?(hex: String?) {
        guard let hex else { return nil }
        var hexFormatted = hex
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .uppercased()
        if hexFormatted.hasPrefix("#") {
            hexFormatted.remove(at: hexFormatted.startIndex)
        }
        if hexFormatted.count == 6 {
            hexFormatted.append("FF")
        }
        guard hexFormatted.count == 8 else { return nil }
        var rgbValue: UInt64 = 0
        guard Scanner(string: hexFormatted).scanHexInt64(&rgbValue) else { return nil }
        let r = Double((rgbValue & 0xFF000000) >> 24) / 255.0
        let g = Double((rgbValue & 0x00FF0000) >> 16) / 255.0
        let b = Double((rgbValue & 0x0000FF00) >> 8) / 255.0
        let a = Double(rgbValue & 0x000000FF) / 255.0
        self.init(.sRGB, red: r, green: g, blue: b, opacity: a)
    }

    // MARK: Methods

    func toHex() -> String? {
        let uiColor = UIColor(self)
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        guard uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha) else { return nil }
        let rInt = Int(red * 255)
        let gInt = Int(green * 255)
        let bInt = Int(blue * 255)
        let aInt = Int(alpha * 255)
        return String(format: "#%02X%02X%02X%02X", rInt, gInt, bInt, aInt)
    }

}

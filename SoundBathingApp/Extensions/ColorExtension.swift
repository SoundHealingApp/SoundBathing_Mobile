//
//  ColorExtension.swift
//  SoundBathingApp
//
//  Created by Ирина Печик on 09.02.2025.
//

import SwiftUI
import UIKit

extension Color {
    static let backgroundColor = Color.adaptive(light: "F2F2F2", dark: "F2F2F2")
    static let blackAdaptive = Color.adaptive(light: "000000", dark: "FFFFFF")
    static let whiteAdaptive = Color.adaptive(light: "FFFFFF", dark: "000000")

    static let buttonGrayStroke = Color(red: 233/255, green: 233/255, blue: 233/255)
    static let textGrayColor = Color(red: 106/255, green: 106/255, blue: 106/255)
    //    static let shadow = Color(uiColor: UIColor(red: 0/255, green: 12/255, blue: 75/255, alpha: 0.06))
    //    static let nextButtonViewSecondTextAndStrokeColor = Color(red: 255/255, green: 213/255, blue: 151/255)
    //    static let nextButtonViewSecondBackgroundColor = Color(red: 49/255, green: 40/255, blue: 36/255)
    //    static let likeColor = Color(red: 191/255, green: 194/255, blue: 200/255)
}

extension Color {
    init(uiColor: UIColor) {
        self.init(UIColor { traitCollection -> UIColor in
            switch traitCollection.userInterfaceStyle {
            case .dark:
                return uiColor
            default:
                return uiColor
            }
        })
    }

    static func adaptive(light: String, dark: String) -> Color {
        Color(uiColor: .adaptiveColor(lightHex: light, darkHex: dark))
    }

    init(hex: String, alpha: Double = 1) {
        var cString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if (cString.hasPrefix("#")) { cString.remove(at: cString.startIndex) }

        let scanner = Scanner(string: cString)
        scanner.currentIndex = scanner.string.startIndex
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        self.init(.sRGB, red: Double(r) / 0xff, green: Double(g) / 0xff, blue:  Double(b) / 0xff, opacity: alpha)
    }
}

extension UIColor {
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (15, (int >> 8), (int >> 4 & 0xF), (int & 0xF))
            self.init(red: CGFloat(r) / 15.0, green: CGFloat(g) / 15.0, blue: CGFloat(b) / 15.0, alpha: alpha)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
            self.init(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: alpha)
        default:
            self.init(red: 0, green: 0, blue: 0, alpha: alpha)
        }
    }

    static func adaptiveColor(lightHex: String, darkHex: String) -> UIColor {
        return UIColor { traitCollection -> UIColor in
            switch traitCollection.userInterfaceStyle {
            case .dark:
                return UIColor(hex: darkHex)
            default:
                return UIColor(hex: lightHex)
            }
        }
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

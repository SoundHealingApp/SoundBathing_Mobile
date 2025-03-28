//
//  FontExtension.swift
//  SoundBathingApp
//
//  Created by Ирина Печик on 08.02.2025.
//

import SwiftUI

enum CustomFonts: String {
    case PlayfairDisplayMedium = "PlayfairDisplay-Medium"
    case OpenSansLight = "OpenSans-Light"
    case FuturaPTLight = "FuturaPT-Light"
    case MarcellusRegular = "Marcellus-Regular"
    case LoraRegular = "Lora-Regular"
    case OpenSansRegular = "OpenSans-Regular"
    case FuturaPTBold = "FuturaPT-Bold"
    case FuturaPTMedium = "FuturaPTCond-Medium"
    case GraphikMedium = "GraphikTrial-Medium"
    case GraphikRegular = "GraphikTrial-Regular"

}

extension Font {
    fileprivate static func custom(_ customFont: CustomFonts, size: CGFloat) -> Font {
        Font.custom(customFont.rawValue, size: size)
    }
}

extension Text {
    func font(customFont: CustomFonts, size: CGFloat) -> Text {
        self.font(Font.custom(customFont, size: size))
    }
}

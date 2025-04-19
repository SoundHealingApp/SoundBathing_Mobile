//
//  DynamicBackround.swift
//  SoundBathingApp
//
//  Created by Ирина Печик on 18.04.2025.
//

import SwiftUI

struct DynamicBackground: View {
    var offset: CGSize = .zero
    
    var body: some View {
        ZStack {
            AngularGradient(gradient: Gradient(colors: [
                Color(hex: "#6A11CB"),
                Color(hex: "#2575FC"),
                Color(hex: "#FF416C"),
                Color(hex: "#11998E"),
                Color(hex: "#6A11CB")
            ]), center: .center)
            .hueRotation(.degrees(offset.width * 0.1))
            .offset(offset)
            .blendMode(.overlay)
            
            Color(hex: "#1A1C2A")
                .opacity(0.9)
        }
    }
}

//
//  ErrorToastView.swift
//  SoundBathingApp
//
//  Created by Ирина Печик on 13.02.2025.
//

import SwiftUI

struct ErrorToastView: View {
    let message: String
    let icon: String
    let gradientColors: [Color]
    let shadowColor: Color
    let cornerRadius: CGFloat
    let shadowRadius: CGFloat
    let shadowOffset: CGSize
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.white)
                .font(.system(size: 20))
            Text(message)
                .font(.system(size: 16))
                .foregroundColor(.white)
        }
        .padding()
        .background(
            LinearGradient(
                gradient: Gradient(colors: gradientColors),
                startPoint: .leading,
                endPoint: .trailing
            )
        )
        .cornerRadius(cornerRadius)
        .shadow(color: shadowColor, radius: shadowRadius, x: shadowOffset.width, y: shadowOffset.height)
    }
}

//
//  StarButton.swift
//  SoundBathingApp
//
//  Created by Ирина Печик on 29.03.2025.
//

import SwiftUI

struct StarButton: View {
    let isFilled: Bool
    let isPulsing: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: isFilled ? "star.fill" : "star")
                .font(.system(size: 36))
                .symbolEffect(.bounce, value: isFilled)
                .scaleEffect(isPulsing ? 1.2 : 1.0)
                .foregroundColor(.orange)
                .animation(.spring(), value: isPulsing)
        }
        .buttonStyle(ScaleButtonStyle())
    }
}

//
//  GradientButton.swift
//  SoundBathingApp
//
//  Created by Ирина Печик on 07.05.2025.
//

import SwiftUI

struct GradientButton: View {
    let title: String
    let disabled: Bool
    let colors: [Color]
    let action: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            action()
        }) {
            Text(title)
                .font(.system(size: 18, weight: .semibold, design: .rounded))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: disabled ? [Color.gray] : colors),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(30)
                .scaleEffect(isPressed ? 0.95 : 1.0)
                .opacity(disabled ? 0.6 : 1.0)
                .animation(.easeInOut(duration: 0.2), value: isPressed)
        }
        .disabled(disabled)
        .buttonStyle(PlainButtonStyle())
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in isPressed = true }
                .onEnded { _ in isPressed = false }
        )
    }
}

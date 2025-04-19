//
//  PracticeSurveyCard.swift
//  SoundBathingApp
//
//  Created by Ирина Печик on 18.04.2025.
//

import SwiftUI

struct PracticeSurveyCard: View {
    let image: UIImage
    let isSelected: Bool
    let isActive: Bool
    
    @State private var isHovering = false
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            /// Изображение практики.
            Image(uiImage: image)
                .resizable()
                .scaledToFill()
                .blendMode(.overlay)
                .opacity(0.8)
                .frame(height: 180)

            /// Галка выбора.
            if isSelected {
                ZStack {
                    Circle()
                        .fill(.white)
                        .frame(width: 28, height: 28)
                        .shadow(color: .black.opacity(0.2), radius: 3, x: 0, y: 2)
                    
                    Image(systemName: "checkmark")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(.black)
                }
                .padding(12)
                .transition(.scale.combined(with: .opacity))
            }
        }
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(isSelected ? .white : .white.opacity(0.3), lineWidth: isSelected ? 2 : 1)
        )
        .scaleEffect(isActive ? 0.95 : 1)
        .shadow(
            color: .indigo.opacity(isSelected ? 0.6 : 0.3),
            radius: isSelected ? 20 : 10,
            x: 0,
            y: isSelected ? 10 : 5
        )
        .animation(.spring(response: 0.3, dampingFraction: 0.5), value: isSelected)
    }
}

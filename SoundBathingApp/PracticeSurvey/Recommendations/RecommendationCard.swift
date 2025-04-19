//
//  RecommendationCard.swift
//  SoundBathingApp
//
//  Created by Ирина Печик on 18.04.2025.
//

import SwiftUI

struct RecommendationCard: View {
    let practice: Practice
    let isSelected: Bool
    let index: Int
    let total: Int
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                /// Фоновая картинка
                Image(uiImage: practice.image)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 140)
                    .clipped()
                    .cornerRadius(20, corners: [.topLeft, .topRight])
                    .overlay(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.black.opacity(0.6), Color.clear]),
                            startPoint: .bottom,
                            endPoint: .center
                        )
                    )
                
                VStack {
                    Spacer()
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(practice.title)
                                .font(.system(size: 18, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                                .lineLimit(2)
                                .shadow(radius: 5)
                            
                            Text(practice.therapeuticPurpose)
                                .font(.system(size: 14, weight: .medium, design: .rounded))
                                .foregroundColor(.white.opacity(0.8))
                                .lineLimit(1)
                                .shadow(radius: 5)
                        }
                        
                        Spacer()
                        
                        Image(systemName: "waveform")
                            .font(.system(size: 22))
                            .foregroundColor(.white.opacity(0.7))
                    }
                    .padding(16)
                }
                .contentShape(Rectangle()) // Это важно для тап-области
            }
            .background(Color.black.opacity(0.2))
            
            if isSelected {
                VStack(spacing: 12) {
                    HStack {
                        Text(practice.meditationType.rawValue)
                            .font(.system(size: 14, weight: .medium, design: .rounded))
                            .foregroundColor(.white.opacity(0.7))
                            .lineLimit(1)
                        
                        Circle()
                            .fill(.white.opacity(0.3))
                            .frame(width: 4, height: 4)
                        
                        if let frequency = practice.frequency {
                            Text("\(String(format: "%.1f", frequency)) Hz")
                                .font(.system(size: 14, weight: .medium, design: .rounded))
                                .foregroundColor(.white.opacity(0.7))
                        } else {
                            Text("Voice guide")
                                .font(.system(size: 14, weight: .medium, design: .rounded))
                                .foregroundColor(.white.opacity(0.7))
                        }
                    }
                    
                    ProgressView(value: 0.7)
                        .tint(.white)
                        .background(Color.white.opacity(0.2))
                }
                .padding(16)
                .background(
                    Color.white.opacity(0.05)
                        .cornerRadius(16, corners: [.bottomLeft, .bottomRight])
                        .offset(y: -10)
                        .padding(.top, -10)
                )
                .transition(.move(edge: .bottom).combined(with: .opacity))
                .zIndex(-1)
                .allowsHitTesting(false)
            }
        }
        .contentShape(Rectangle())
        .cornerRadius(20)
        .shadow(color: Color.indigo.opacity(isSelected ? 0.4 : 0.2),
                radius: isSelected ? 20 : 10,
                x: 0,
                y: isSelected ? 10 : 5)
        .scaleEffect(isSelected ? 1.02 : 1)
        .zIndex(isSelected ? 100 : Double(total - index))
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isSelected)
    }
}


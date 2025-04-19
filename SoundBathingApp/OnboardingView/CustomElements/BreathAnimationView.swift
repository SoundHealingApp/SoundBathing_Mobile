//
//  BreathAnimationView.swift
//  SoundBathingApp
//
//  Created by Ирина Печик on 20.04.2025.
//

import SwiftUI

struct BreathAnimationView: View {
    @State private var scale: CGFloat = 0.9
    @State private var opacity: Double = 0.7
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(#colorLiteral(red: 0.38, green: 0.8, blue: 0.96, alpha: 1)),
                            Color(#colorLiteral(red: 0.8, green: 0.4, blue: 0.96, alpha: 1))
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    style: StrokeStyle(lineWidth: 8, lineCap: .round, dash: [60, 30])
                )
                .frame(width: 180, height: 180)
                .scaleEffect(scale)
                .opacity(opacity)
                .rotationEffect(.degrees(scale * 20))
            
            Circle()
                .stroke(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(#colorLiteral(red: 0.8, green: 0.4, blue: 0.96, alpha: 1)),
                            Color(#colorLiteral(red: 0.38, green: 0.8, blue: 0.96, alpha: 1))
                        ]),
                        startPoint: .topTrailing,
                        endPoint: .bottomLeading
                    ),
                    style: StrokeStyle(lineWidth: 6, lineCap: .round, dash: [40, 20])
                )
                .frame(width: 120, height: 120)
                .scaleEffect(scale * 0.9)
                .opacity(opacity * 0.9)
                .rotationEffect(.degrees(-scale * 30))
            
            Circle()
                .fill(
                    RadialGradient(
                        gradient: Gradient(colors: [
                            Color(#colorLiteral(red: 0.38, green: 0.8, blue: 0.96, alpha: 1)),
                            Color(#colorLiteral(red: 0.8, green: 0.4, blue: 0.96, alpha: 1))
                        ]),
                        center: .center,
                        startRadius: 0,
                        endRadius: 20
                    )
                )
                .frame(width: 24, height: 24)
                .shadow(color: Color(#colorLiteral(red: 0.38, green: 0.8, blue: 0.96, alpha: 0.5)), radius: 16)
        }
        .onAppear {
            withAnimation(Animation.easeInOut(duration: 4).repeatForever(autoreverses: true)) {
                scale = 1.1
                opacity = 1.0
            }
        }
    }
}
#Preview {
    BreathAnimationView()
}

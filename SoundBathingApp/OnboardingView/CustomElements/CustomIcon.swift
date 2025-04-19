//
//  CustomIcon.swift
//  SoundBathingApp
//
//  Created by Ирина Печик on 20.04.2025.
//

import SwiftUI

struct CustomIcon: View {
    let systemName: String
    let gradient: [Color]
    @State private var rotation: Double = 0
    
    var body: some View {
        ZStack {
            Circle()
                .fill(
                    AngularGradient(
                        gradient: Gradient(colors: gradient),
                        center: .center,
                        startAngle: .degrees(0),
                        endAngle: .degrees(360)
                    )
                )
                .frame(width: 120, height: 120)
                .rotationEffect(.degrees(rotation))
                .blur(radius: 20)
                .opacity(0.7)
            
            Image(systemName: systemName)
                .font(.system(size: 50, weight: .thin))
                .foregroundColor(.white)
                .frame(width: 100, height: 100)
                .background(
                    Circle()
                        .fill(Color.black.opacity(0.3))
                        .blur(radius: 2)
                )
        }
        .onAppear {
            withAnimation(Animation.linear(duration: 12).repeatForever(autoreverses: false)) {
                rotation = 360
            }
        }
    }
}

//
//  LoadingView.swift
//  SoundBathingApp
//
//  Created by Ирина Печик on 07.05.2025.
//

import SwiftUI

struct LoadingView: View {
    let colors: [Color]
    @State private var isAnimating = false
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .edgesIgnoringSafeArea(.all)
            
            Circle()
                .trim(from: 0, to: 0.7)
                .stroke(
                    AngularGradient(
                        gradient: Gradient(colors: colors),
                        center: .center,
                        startAngle: .degrees(0),
                        endAngle: .degrees(360)
                    ),
                    style: StrokeStyle(lineWidth: 8, lineCap: .round)
                )
                .frame(width: 50, height: 50)
                .rotationEffect(Angle(degrees: isAnimating ? 360 : 0))
                .animation(
                    Animation.linear(duration: 1).repeatForever(autoreverses: false),
                    value: isAnimating
                )
                .onAppear {
                    isAnimating = true
                }
        }
    }
}

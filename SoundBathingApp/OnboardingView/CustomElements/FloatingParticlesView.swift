//
//  FloatingParticlesView.swift
//  SoundBathingApp
//
//  Created by Ирина Печик on 20.04.2025.
//

import SwiftUI

struct FloatingParticlesView: View {
    let particleColor: Color
    @State private var particles: [Particle] = []
    
    struct Particle {
        var x: CGFloat
        var y: CGFloat
        var size: CGFloat
        var opacity: Double
        var speed: Double
        var xOffset: Double
        var yOffset: Double
    }
    
    init(particleColor: Color = Color(red: 0.7, green: 0.4, blue: 1.0)) {
        self.particleColor = particleColor
        // Initialize particles
        _particles = State(initialValue: (0..<50).map { _ in
            Particle(
                x: CGFloat.random(in: 0..<1),
                y: CGFloat.random(in: 0..<1),
                size: CGFloat.random(in: 1..<3),
                opacity: Double.random(in: 0.1..<0.5),
                speed: Double.random(in: 2..<5),
                xOffset: Double.random(in: -0.5..<0.5),
                yOffset: Double.random(in: -0.5..<0.5)
            )
        })
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(particles.indices, id: \.self) { index in
                    Circle()
                        .fill(particleColor)
                        .frame(width: particles[index].size, height: particles[index].size)
                        .position(
                            x: particles[index].x * geometry.size.width,
                            y: particles[index].y * geometry.size.height
                        )
                        .opacity(particles[index].opacity)
                        .onAppear {
                            withAnimation(
                                Animation.easeInOut(duration: particles[index].speed)
                                    .repeatForever(autoreverses: true)
                            ) {
                                particles[index].x += CGFloat(particles[index].xOffset)
                                particles[index].y += CGFloat(particles[index].yOffset)
                                particles[index].opacity = Double.random(in: 0.1..<0.8)
                            }
                        }
                }
            }
        }
        .ignoresSafeArea()
    }
}

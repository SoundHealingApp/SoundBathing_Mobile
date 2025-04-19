//
//  FloatingParticlesView.swift
//  SoundBathingApp
//
//  Created by Ирина Печик on 20.04.2025.
//

import SwiftUI

struct FloatingParticlesView: View {
    @State private var particles: [Particle] = []
    
    /// Модель данных частицы.
    struct Particle: Identifiable {
        let id = UUID()
        var x: CGFloat
        var y: CGFloat
        var size: CGFloat
        var speed: CGFloat /// Скорость перемещения.
        var opacity: Double
    }
    
    var body: some View {
        GeometryReader { geometry in
            ForEach(particles) { particle in
                Circle()
                    .fill(Color.white)
                    .frame(width: particle.size, height: particle.size)
                    .position(x: particle.x, y: particle.y)
                    .opacity(particle.opacity)
                    .animation(.linear(duration: particle.speed)
                        .repeatForever(autoreverses: true), value: particle.opacity)
            }
        }
        .onAppear {
            /// Создаем 30 частиц.
            var newParticles: [Particle] = []
            for _ in 0..<30 {
                newParticles.append(
                    Particle(
                        x: CGFloat.random(in: 0..<UIScreen.main.bounds.width),
                        y: CGFloat.random(in: 0..<UIScreen.main.bounds.height),
                        size: CGFloat.random(in: 1..<4),
                        speed: Double.random(in: 4..<8),
                        opacity: Double.random(in: 0.02..<0.1)
                    )
                )
            }
            particles = newParticles
        }
    }
}

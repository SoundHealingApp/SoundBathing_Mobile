//
//  ConfettiView.swift
//  SoundBathingApp
//
//  Created by Ирина Печик on 07.05.2025.
//

import SwiftUI

struct ConfettiView: View {
    let colors: [Color]
    @State private var confettiPieces: [ConfettiPiece] = []
    
    struct ConfettiPiece {
        var x: CGFloat
        var y: CGFloat
        var rotation: Double
        var rotationSpeed: Double
        var speed: Double
        var color: Color
        var shape: ConfettiShape
    }
    
    enum ConfettiShape {
        case rectangle, circle, triangle
    }
    
    init(colors: [Color]) {
        self.colors = colors
        // Инициализируем конфетти
        _confettiPieces = State(initialValue: (0..<50).map { _ in
            ConfettiPiece(
                x: CGFloat.random(in: 0..<1),
                y: CGFloat.random(in: -1..<0),
                rotation: Double.random(in: 0..<360),
                rotationSpeed: Double.random(in: 1..<5),
                speed: Double.random(in: 2..<8),
                color: colors.randomElement() ?? .white,
                shape: [.rectangle, .circle, .triangle].randomElement()!
            )
        })
    }
    
    var body: some View {
        GeometryReader { geometry in
            ForEach(confettiPieces.indices, id: \.self) { index in
                ConfettiShapeView(shape: confettiPieces[index].shape, color: confettiPieces[index].color)
                    .frame(width: 10, height: 10)
                    .position(
                        x: confettiPieces[index].x * geometry.size.width,
                        y: confettiPieces[index].y * geometry.size.height
                    )
                    .rotationEffect(.degrees(confettiPieces[index].rotation))
                    .onAppear {
                        withAnimation(
                            Animation.timingCurve(0.1, 0.8, 0.1, 1, duration: confettiPieces[index].speed)
                        ) {
                            confettiPieces[index].y += 1.5
                            confettiPieces[index].rotation += confettiPieces[index].rotationSpeed * 360
                        }
                    }
            }
        }
    }
}

struct ConfettiShapeView: View {
    let shape: ConfettiView.ConfettiShape
    let color: Color
    
    var body: some View {
        Group {
            switch shape {
            case .rectangle:
                Rectangle().fill(color)
            case .circle:
                Circle().fill(color)
            case .triangle:
                Triangle().fill(color)
            }
        }
    }
}

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
        
        return path
    }
}

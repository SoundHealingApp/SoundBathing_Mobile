//
//  StarFieldView.swift
//  SoundBathingApp
//
//  Created by Ирина Печик on 07.05.2025.
//

import SwiftUI

struct StarFieldView: View {
    @State private var stars: [Star] = []
    
    struct Star {
        var x: CGFloat
        var y: CGFloat
        var size: CGFloat
        var opacity: Double
        var speed: Double
    }
    
    init() {
        // Инициализируем звезды
        _stars = State(initialValue: (0..<100).map { _ in
            Star(
                x: CGFloat.random(in: 0..<1),
                y: CGFloat.random(in: 0..<1),
                size: CGFloat.random(in: 0.5..<3),
                opacity: Double.random(in: 0.1..<1),
                speed: Double.random(in: 0.01..<0.05)
            )
        })
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(stars.indices, id: \.self) { index in
                    Circle()
                        .fill(Color.white)
                        .frame(width: stars[index].size, height: stars[index].size)
                        .position(
                            x: stars[index].x * geometry.size.width,
                            y: stars[index].y * geometry.size.height
                        )
                        .opacity(stars[index].opacity)
                        .onAppear {
                            withAnimation(
                                Animation.linear(duration: Double.random(in: 2..<5))
                                    .repeatForever(autoreverses: true)
                            ) {
                                stars[index].opacity = Double.random(in: 0.1..<0.8)
                            }
                        }
                }
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    StarFieldView()
}

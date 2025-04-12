//
//  VibratingWaveBackground.swift
//  SoundBathingApp
//
//  Created by Ирина Печик on 10.04.2025.
//

import SwiftUI

struct VibratingWaveBackgroundView: View {
    @State private var phase: CGFloat = 0
    
    var body: some View {
        ZStack {
                // Фон с градиентом
                LinearGradient(
                    colors: [Color(#colorLiteral(red: 0.8896105886, green: 0.8780847192, blue: 0.9862286448, alpha: 1)), Color(#colorLiteral(red: 0.6817207336, green: 0.6919837594, blue: 0.9618334174, alpha: 1))],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
            
            // Анимированные вибрирующие волны
            TimelineView(.animation) { timeline in
                Canvas { context, size in
                    let time = timeline.date.timeIntervalSinceReferenceDate
                    let center = CGPoint(x: size.width / 2, y: size.height / 2)
                    let maxRadius = min(size.width, size.height) * 0.45
                    
                    // Параметры вибрации
                    let vibrationIntensity: CGFloat = 0.05
                    let vibrationSpeed: CGFloat = 2.0
                    let waveFrequency: CGFloat = 7.0
                    
                    // Рисуем несколько слоев волн
                    for i in 1...5 {
                        let radius = maxRadius * CGFloat(i)/5
                        var path = Path()
                        
                        for angle in stride(from: 0, through: 360, by: 0.5) {
                            let radian = Angle(degrees: Double(angle)).radians
                            
                            // Эффект вибрации + волны
                            let vibration = sin(CGFloat(time) * vibrationSpeed * 2) * vibrationIntensity
                            let wave = sin(radian * waveFrequency + CGFloat(time) * 3.0) * 0.1
                            let noise = 1.0 + vibration + wave
                            
                            let pointRadius = radius * noise
                            let x = center.x + cos(radian) * pointRadius
                            let y = center.y + sin(radian) * pointRadius
                            
                            if angle == 0 {
                                path.move(to: CGPoint(x: x, y: y))
                            } else {
                                path.addLine(to: CGPoint(x: x, y: y))
                            }
                        }
                        
                        path.closeSubpath()
                        
                        // Разные стили для каждого слоя
                        let opacity = 0.7 - Double(i) * 0.12
                        let lineWidth: CGFloat = i == 3 ? 3 : (i == 2 || i == 4 ? 2 : 1)
                        
                        context.stroke(
                            path,
                            with: .color(Color.black.opacity(0.1)),
                            lineWidth: lineWidth
                        )
                    }
                }
            }
        }
    }
}

#Preview {
    WelcomeQuoteView(showMainView: .constant(false))
}

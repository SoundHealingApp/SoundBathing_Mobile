//
//  QuoteCardView.swift
//  SoundBathingApp
//
//  Created by Ирина Печик on 08.04.2025.
//

import SwiftUI

struct QuoteCardView: View {
    let quote: Quote
    @State private var isTapped = false
    @State private var showShareSheet = false
    @State private var cardRotation: Double = 0
    
    /// Случайный градиент для карточки
    private var cardGradient: LinearGradient {
        let gradients = [
            [Color(#colorLiteral(red: 0.4, green: 0.3, blue: 0.8, alpha: 1)), Color(#colorLiteral(red: 0.3, green: 0.2, blue: 0.6, alpha: 1))],
            [Color(#colorLiteral(red: 0.2, green: 0.5, blue: 0.8, alpha: 1)), Color(#colorLiteral(red: 0.1, green: 0.3, blue: 0.6, alpha: 1))],
            [Color(#colorLiteral(red: 0.8, green: 0.2, blue: 0.4, alpha: 1)), Color(#colorLiteral(red: 0.6, green: 0.1, blue: 0.3, alpha: 1))]
        ]
        let randomGradient = gradients.randomElement() ?? gradients[0]
        return LinearGradient(
            colors: randomGradient.map { Color($0) },
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            /// Кнопка поделиться
            HStack {
                Spacer()
                Button(action: {
                    showShareSheet = true
                }) {
                    Image(systemName: "square.and.arrow.up")
                        .font(.system(size: 18))
                        .foregroundColor(.white.opacity(0.8))
                }
            }
            
            /// Текст цитаты
            Text(quote.text)
                .font(.system(.title3, design: .rounded))
                .fontWeight(.medium)
                .foregroundColor(.white)
                .lineSpacing(6)
                .frame(maxWidth: .infinity, alignment: .leading)
                .multilineTextAlignment(.leading)
                .blur(radius: isTapped ? 0.8 : 0)
                .padding(.vertical, 8)
            
            /// Автор
            HStack {
                ForEach(0..<3) { _ in
                    Circle()
                        .frame(width: 6, height: 6)
                        .foregroundColor(.white.opacity(0.5))
                }
                
                Spacer()
                
                Text("- \(quote.author)")
                    .font(.system(.callout, design: .rounded))
                    .fontWeight(.semibold)
                    .foregroundColor(.white.opacity(0.9))
                    .padding(.leading, 8)
            }
            .padding(.top, 4)
        }
        .padding(20)
        .background(
            ZStack {
                /// Основной градиент
                cardGradient
                
                /// Текстурный эффект
                AngularGradient(
                    gradient: Gradient(colors: [
                        .clear, .clear, .clear, .clear,
                        .white.opacity(0.1),
                        .clear, .clear, .clear
                    ]),
                    center: .center,
                    angle: .degrees(cardRotation)
                )
                .blendMode(.overlay)
                
                /// Эффект частиц при нажатии
                if isTapped {
                    ForEach(0..<8) { i in
                        Circle()
                            .fill(Color.white.opacity(0.3))
                            .frame(width: 6, height: 6)
                            .position(
                                x: CGFloat.random(in: 0...UIScreen.main.bounds.width/2),
                                y: CGFloat.random(in: 0...200)
                            )
                            .transition(.opacity.combined(with: .scale))
                    }
                }
            }
            .cornerRadius(20)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(.white.opacity(0.2), lineWidth: 1)
                .shadow(color: .white.opacity(0.3), radius: 2, x: 0, y: 0)
        )
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.2), radius: 15, x: 0, y: 10)
        .scaleEffect(isTapped ? 0.97 : 1.0)
        .rotation3DEffect(
            .degrees(isTapped ? -2 : 0),
            axis: (x: 1, y: -1, z: 0),
            perspective: 0.5
        )
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isTapped)
        .onAppear {
            withAnimation(Animation.linear(duration: 15).repeatForever(autoreverses: false)) {
                cardRotation = 360
            }
        }
        .gesture(
            TapGesture()
                .onEnded { _ in
                    isTapped = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        isTapped = false
                    }
                    
                    /// Вибрация при нажатии
                    let generator = UIImpactFeedbackGenerator(style: .light)
                    generator.impactOccurred()
                }
        )
        .sheet(isPresented: $showShareSheet) {
            ActivityView(activityItems: ["\(quote.text)\n\n— \(quote.author)"])
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 6)
    }
}

/// Вспомогательная view для шеринга цитаты
struct ActivityView: UIViewControllerRepresentable {
    var activityItems: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(
            activityItems: activityItems,
            applicationActivities: nil
        )
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

#Preview {
    QuoteCardView(quote: Quote(author: "author", text: "text"))
}

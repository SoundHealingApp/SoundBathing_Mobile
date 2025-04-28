//
//  WelcomeQuoteView.swift
//  SoundBathingApp
//
//  Created by Ирина Печик on 09.04.2025.
//

import SwiftUI

struct WelcomeQuoteView: View {
    @EnvironmentObject var appViewModel: AppViewModel

    @State private var isAnimating = false
    @State private var showUI = false
    @State private var timer: Timer?

    @State private var quote: Quote = Quote(
        id: UUID().uuidString,
        author: "Anonymous",
        text: "Don’t compare someone’s middle to your beginning."
    )
    @StateObject private var quotesViewModel = QuotesViewModel()


    var body: some View {
        ZStack {
            /// Фон
            DynamicBackground()
                .ignoresSafeArea()
                .blur(radius: 20)

            VStack {
                Spacer()

                /// Цитата
                VStack(alignment: .trailing, spacing: 10) {
                    Text(quote.text)
                        .font(.system(.title, design: .rounded))
                        .fontWeight(.medium)
                        .foregroundColor(.white.opacity(0.8))
                        .opacity(showUI ? 1 : 0)
                        .offset(y: showUI ? 0 : 20)
                        .animation(.easeOut(duration: 0.6).delay(0.3), value: showUI)


                    Text("- \(quote.author)")
                        .font(.system(.title3, design: .rounded))
                        .fontWeight(.light)
                        .foregroundColor(.white.opacity(0.8))
                        .padding(.top, 10)
                        .opacity(showUI ? 1 : 0)
                        .offset(y: showUI ? 0 : 20)
                        .animation(.easeOut(duration: 0.6).delay(0.4), value: showUI)
                }
                .padding(.horizontal, 30)
                .padding(.vertical, 40)
                .padding(.horizontal, 20)
                .scaleEffect(isAnimating ? 1.02 : 1)
                .rotation3DEffect(
                    .degrees(isAnimating ? 1 : 0),
                    axis: (x: 1, y: -1, z: 0)
                )

                Spacer()

                /// Кнопка продолжения
                Button(action: {
                    Task {
                        await appViewModel.hideWelcomeQuote()
                    }
                }) {
                    HStack {
                        Text("Continue")
                        Image(systemName: "arrow.right")
                    }
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .foregroundColor(.black)
                    .padding(.horizontal, 36)
                    .padding(.vertical, 16)
                    .background(
                        Capsule()
                            .fill(Color.white.opacity(0.8))
                            .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
                    )
                }
                .opacity(showUI ? 1 : 0)
                .offset(y: showUI ? 0 : 20)
                .animation(.easeOut(duration: 0.8).delay(0.7), value: showUI)
                .padding(.bottom, 50)
            }
        }
        .onAppear {
            startTimer()
            loadQuote()
            
            /// Запуск анимаций
            withAnimation(.easeInOut(duration: 3).repeatForever()) {
                isAnimating = true
            }

            withAnimation(.spring().delay(0.5)) {
                showUI = true
            }
        }
        .onDisappear {
            timer?.invalidate()
        }
    }
    
    private func loadQuote() {
        Task {
            quote = await quotesViewModel.getDailyRandomQuote() ?? Quote(
                id: UUID().uuidString,
                author: "Anonymous",
                text: "Don’t compare someone’s middle to your beginning."
            )
        }
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: false) { _ in
            dismissAfterAnimation()
        }
    }
    
    private func dismissAfterAnimation() {
        withAnimation(.easeOut(duration: 0.3)) {
            Task {
                await appViewModel.hideWelcomeQuote()
            }
        }
    }
    
//    private func startTimer() {
//        timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: false) { _ in
//            dismissAfterAnimation()
//        }
//    }
//    
//    private func dismissAfterAnimation() {
//        withAnimation(.easeOut(duration: 0.3)) {
////            showMainView = true
//            showSurveyView = true
//        }
//    }
}
#Preview {
    WelcomeQuoteView()
}

//
//  PreAuthOnboardingView.swift
//  SoundBathingApp
//
//  Created by Ирина Печик on 19.04.2025.
//

import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var appViewModel: AppViewModel

    @State private var currentPage = 0
    @State private var showHint = false
    
    /// Задний фон.
    let backgroundGradient = LinearGradient(
        gradient: Gradient(colors: [
            Color(#colorLiteral(red: 0.05, green: 0.06, blue: 0.1, alpha: 1)),
            Color(#colorLiteral(red: 0.1, green: 0.12, blue: 0.2, alpha: 1))
        ]),
        startPoint: .top,
        endPoint: .bottom
    )
    
    let primaryColor = Color.white
    let accentColor = Color(#colorLiteral(red: 0.5809736252, green: 0.6380921006, blue: 0.9672341943, alpha: 1))
    
    var body: some View {
        ZStack {
            backgroundGradient.ignoresSafeArea()
            
            /// Звездочки на фоне.
            FloatingParticlesView()
            
            TabView(selection: $currentPage) {
                /// Экран 1
                FindPeaceView(primaryColor: primaryColor)
                .tag(0)
                
                /// Экран 2
                BreatheDeeplyView(primaryColor: primaryColor)
                .tag(1)
                
                /// Экран 3
                MindfulMomentsView(primaryColor: primaryColor)
                .tag(2)
                
                // Экран 4
                BeginJourneyView(primaryColor: primaryColor, accentColor: accentColor)
                .tag(3)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            
            /// Стрелка свайпа
            if showHint {
                VStack {
                    Spacer()
                    
                    HStack(spacing: 8) {
                        Image(systemName: "arrow.left")
                        Text("Swipe to continue")
                        Image(systemName: "arrow.right")
                    }
                    .font(.system(size: 16, weight: .thin, design: .rounded))
                    .foregroundColor(primaryColor.opacity(0.6))
                    .padding(.bottom, 40)
                    .transition(.opacity)
                }
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                withAnimation {
                    showHint = true
                }
            }
        }
        .onChange(of: currentPage) { _ in
            showHint = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                withAnimation {
                    showHint = false
                }
            }
        }
    }
}


struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}

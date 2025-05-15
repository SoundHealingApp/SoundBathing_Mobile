//
//  BirthdateEnteringView2.swift
//  SoundBathingApp
//
//  Created by Ирина Печик on 07.05.2025.
//

import SwiftUI

struct BirthdateEnteringView: View {
    @State private var date: Date = Calendar.current.date(byAdding: .year, value: -18, to: Date()) ?? Date()
    @State private var showErrorToast = false
    @State private var showConfetti = false
    
    @StateObject var birthDateViewModel = BirthDateViewModel()
    @StateObject var createUserViewModel = CreateUserViewModel()
    
    @EnvironmentObject var appViewModel: AppViewModel
    
    let backgroundGradient = LinearGradient(
        gradient: Gradient(colors: [
            Color(#colorLiteral(red: 0.05, green: 0.06, blue: 0.1, alpha: 1)),
            Color(#colorLiteral(red: 0.1, green: 0.12, blue: 0.2, alpha: 1))
        ]),
        startPoint: .top,
        endPoint: .bottom
    )
    
    var body: some View {
        ZStack {
            backgroundGradient.ignoresSafeArea()
            
            // Конфетти при успешной регистрации
            if showConfetti {
                ConfettiView(colors: [.purple, .blue, .white])
                    .transition(.opacity)
            }
            
            VStack(spacing: 40) {
                if showErrorToast {
                    ErrorToastView(
                        message: "Something went wrong",
                        icon: "exclamationmark.triangle.fill",
                        gradientColors: [Color.red.opacity(0.9), Color.orange.opacity(0.9)],
                        shadowColor: Color.black.opacity(0.2),
                        cornerRadius: 15,
                        shadowRadius: 10,
                        shadowOffset: CGSize(width: 0, height: 5)
                    )
                    .transition(.move(edge: .top).combined(with: .opacity))
                    .animation(.spring(response: 0.5, dampingFraction: 0.6, blendDuration: 0), value: showErrorToast)
                    .zIndex(1)
                }
                
                Spacer()
                
                // Анимированный заголовок
                VStack(spacing: 10) {
                    Text("When's Your Birthday?")
                        .font(.system(size: 30, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .shadow(color: Color.purple.opacity(0.5), radius: 10, x: 0, y: 0)
                    
                    Text("We'll make sure to celebrate!")
                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                        .opacity(0.8)
                        .foregroundColor(Color(red: 0.8, green: 0.8, blue: 1.0))
                }
                
                BirthDateView(date: $date)
                    .frame(height: 200)
                    .padding(.top, 40)
                    .padding(.horizontal, 20)
                
                Spacer()
                
                GradientButton(
                    title: "Register",
                    disabled: false,
                    colors: [Color(red: 0.6, green: 0.2, blue: 1.0), Color(red: 0.4, green: 0.1, blue: 0.8)],
                    action: {
                        birthDateViewModel.saveBirthBateToUserDefaults(birthDate: date)
                        Task {
                            await createUserViewModel.sendCreateUserRequestAsync()
                        }
                    }
                )
                .padding(.bottom, 30)
                .shadow(color: Color.purple.opacity(0.5), radius: 10, x: 0, y: 5)
            }
            .padding(.horizontal, 25)
            
            if createUserViewModel.isLoading {
                LoadingView(colors: [.purple, .indigo])
            }
        }
        .onChange(of: createUserViewModel.isUserCreatedSuccessful) { _, newValue in
            if newValue {
                withAnimation {
                    showConfetti = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    appViewModel.completeSignUp()
                }
            }
        }
        .onChange(of: createUserViewModel.errorMessage) { _, newValue in
            if newValue != nil {
                withAnimation(.spring()) {
                    showErrorToast = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    withAnimation {
                        showErrorToast = false
                    }
                }
            }
        }
    }
}

#Preview {
    BirthdateEnteringView()
}

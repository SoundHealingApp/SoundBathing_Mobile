//
//  BirthDateView.swift
//  SoundBathingApp
//
//  Created by Ирина Печик on 13.02.2025.
//


import SwiftUI

struct BirthdateEnteringView: View {
    @State private var date: Date = Date.now
    @State private var surname: String = ""
    @State private var presentNextView = false
    @State private var showErrorToast = false

    @StateObject var birthDateViewModel = BirthDateViewModel()
    @StateObject var createUserViewModel = CreateUserViewModel()
    
    @EnvironmentObject var appViewModel: AppViewModel

    var body: some View {
        ZStack {
            VStack(alignment: .center, spacing: 40) {
                if showErrorToast {
                    ErrorToastView(
                        message: createUserViewModel.errorMessage ?? "Something went wrong",
                        icon: "exclamationmark.triangle.fill",
                        gradientColors: [Color.red.opacity(0.9), Color.orange.opacity(0.9)],
                        shadowColor: Color.black.opacity(0.2),
                        cornerRadius: 15,
                        shadowRadius: 10,
                        shadowOffset: CGSize(width: 0, height: 5)
                    )
                    .transition(.move(edge: .top).combined(with: .opacity))
                    .animation(.spring(response: 0.5, dampingFraction: 0.6, blendDuration: 0), value: showErrorToast)
                } 
                Text("Enter your birthdate")
                    .font(.custom("Lora-Regular", size: 32))
                    .padding(.bottom, 70)
                
                BirthDateView(date: $date)
                
                CustomButtonView(text: "Next", isDisabled: false) {
                    birthDateViewModel.saveBirthBateToUserDefaults(birthDate: date)
                    Task {
                        await createUserViewModel.sendCreateUserRequestAsync()
                    }
                }
                .padding(.top, 100)
            }
            .onChange(of: createUserViewModel.isUserCreatedSuccessful) { _, newValue in
                if newValue {
                    appViewModel.completeSignUp()
                }
            }
            .onChange(of: createUserViewModel.errorMessage) { _, newValue in
                if newValue != nil {
                    withAnimation {
                        showErrorToast = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        withAnimation {
                            showErrorToast = false
                        }
                    }
                }
            }
            .padding()
            
            if createUserViewModel.isLoading {
                Color.black.opacity(0.4) // Затемнение фона
                    .edgesIgnoringSafeArea(.all)
    
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .scaleEffect(2) // Увеличение индикатора
            }
        }
    }
}

#Preview {
    BirthdateEnteringView()
}

//
//  TryRegisterView.swift
//  SoundBathingApp
//
//  Created by Ирина Печик on 07.05.2025.
//

import SwiftUI

struct RegisterView: View {
    @EnvironmentObject var appViewModel: AppViewModel
    @StateObject var viewModel = CheckUserExistenceViewModel()
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var repeatedPassword: String = ""
    
    @State private var isEmailValid = false
    @State private var isPasswordValid = false
    @State private var passwordsMatch = false
    
    @State private var showErrorToast = false
    @State private var showSuccessAnimation = false
    
    let backgroundGradient = LinearGradient(
        gradient: Gradient(colors: [
            Color(#colorLiteral(red: 0.05, green: 0.06, blue: 0.1, alpha: 1)),
            Color(#colorLiteral(red: 0.1, green: 0.12, blue: 0.2, alpha: 1))
        ]),
        startPoint: .top,
        endPoint: .bottom
    )
    
    @FocusState private var focusedField: FocusedField?
    
    private var isNextButtonDisabled: Bool {
        !isEmailValid || !isPasswordValid || !passwordsMatch
    }
    
    var body: some View {
        ZStack {
            /// Фон с градиентом
            backgroundGradient
                .ignoresSafeArea()

            VStack(spacing: 30) {
                if showErrorToast {
                    ErrorToastView(
                        message: viewModel.errorMessage ?? "Something went wrong",
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
                
                VStack(spacing: 8) {
                    Text("Create Account")
                        .font(.system(size: 36, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .shadow(color: Color.purple.opacity(0.5), radius: 10, x: 0, y: 0)
                    
                    Text("Begin your mindful journey")
                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                        .opacity(0.8)
                        .foregroundColor(Color(red: 0.8, green: 0.8, blue: 1.0))
                }
                .padding(.bottom, 20)
                
                VStack(spacing: 25) {
                    EmailField(
                        email: $email,
                        placeholder: "Email",
                        validation: { Validator.isEmailCorrect($0) },
                        onValidationChanged: { isValid in
                            isEmailValid = isValid
                        }
                    )

                    /// Основное поле пароля
                    PasswordField(
                        password: $password,
                        placeholder: "Password",
                        icon: "lock.fill",
                        validation: { Validator.isPasswordCorrect(password: $0) },
                        onValidationChanged: { isValid in
                            isPasswordValid = isValid
                        },
                        showStrengthIndicator: true,
                        otherPassword: repeatedPassword
                    )
                    .onChange(of: password) { _, newValue in
                        passwordsMatch = !repeatedPassword.isEmpty && repeatedPassword == newValue
                    }


                    /// Повторное поле пароля
                    PasswordField(
                        password: $repeatedPassword,
                        placeholder: "Repeat Password",
                        icon: "lock.fill",
                        validation: { $0 == password && !password.isEmpty },
                        onValidationChanged: { isValid in
                            passwordsMatch = isValid
                        },
                        showStrengthIndicator: false,
                        otherPassword: password
                    )
                    .onChange(of: repeatedPassword) { _, newValue in
                        passwordsMatch = !password.isEmpty && password == newValue
                    }
                }
                
                Spacer()
                
                /// Кнопка с градиентным эффектом
                GradientButton(
                    title: "Continue",
                    disabled: isNextButtonDisabled,
                    colors: [Color(red: 0.6, green: 0.2, blue: 1.0), Color(red: 0.4, green: 0.1, blue: 0.8)],
                    action: {
                        Task {
                            await viewModel.checkUserExistence(email: email, password: password)
                        }
                    }
                )
                .padding(.bottom, 30)
                .shadow(color: Color.purple.opacity(0.5), radius: 10, x: 0, y: 5)
            }
            .padding(.horizontal, 25)
            
            if viewModel.isLoading {
                LoadingView(colors: [.purple, .indigo])
            }
        }
        .onChange(of: viewModel.isCheckedSuccessful) { _, newValue in
            if newValue {
                withAnimation {
                    showSuccessAnimation = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    appViewModel.showNameEntering()
                }
            }
        }
        .onChange(of: viewModel.errorMessage) { _, newValue in
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
    RegisterView()
}

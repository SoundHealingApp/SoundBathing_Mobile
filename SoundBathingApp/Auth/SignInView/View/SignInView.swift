//
//  SignInView.swift
//  SoundBathingApp
//
//  Created by Ирина Печик on 15.02.2025.
//

import SwiftUI

struct SignInView: View {
    @EnvironmentObject var appViewModel: AppViewModel
    @EnvironmentObject var viewModel: SignInViewModel
    
    @State private var email = ""
    @State private var password = ""
    
    @State private var isEmailValid = true
    @State private var isPasswordValid = true
    @State private var shouldShowSignUpView = false
    @FocusState private var focusedField: FocusedField?
    @State private var showErrorToast = false

    private var isSignInButtonDisabled: Bool {
        !Validator.isEmailCorrect(email) || password.isEmpty
    }
    
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
            // Фон с градиентом
            backgroundGradient
                .ignoresSafeArea()
            
            FloatingParticlesView()

            VStack {
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
                }
                Spacer()

                VStack(spacing: 20) {
                    CustomIcon(systemName: "figure.mind.and.body",
                             gradient: [Color(#colorLiteral(red: 0.8, green: 0.88, blue: 1, alpha: 1)),
                                       Color(#colorLiteral(red: 0.38, green: 0.8, blue: 0.96, alpha: 1))])
                    VStack(spacing: 10) {
                        Text("Sign in")
                            .font(.system(size: 36, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .shadow(color: Color.purple.opacity(0.5), radius: 10, x: 0, y: 0)
                        
                        Text("Continue your mindful journey")
                            .font(.system(size: 18, weight: .semibold, design: .rounded))
                            .opacity(0.8)
                            .foregroundColor(Color(red: 0.8, green: 0.8, blue: 1.0))
                    }
                }
                .padding(.bottom, 20)
                
                VStack(spacing: 25) {
                    EmailField(
                        email: $email,
                        placeholder: "Email",
                        validation: { Validator.isEmailCorrect($0) },
                        onValidationChanged: { _ in }
                    )
                    
                    // Поле пароля (без валидации)
                    PasswordField(
                        password: $password,
                        placeholder: "Password",
                        icon: "lock.fill",
                        validation: { _ in true },
                        onValidationChanged: { _ in },
                        showStrengthIndicator: false,
                        otherPassword: ""
                    )
                }
                                
                VStack(spacing: 0) {
                    /// Кнопка с градиентным эффектом
                    GradientButton(
                        title: "Sign in",
                        disabled: isSignInButtonDisabled,
                        colors: [Color(red: 0.6, green: 0.2, blue: 1.0), Color(red: 0.4, green: 0.1, blue: 0.8)],
                        action: {
                            Task {
                                await viewModel.sendSignInRequestAsync(email: email, password: password)
                            }
                        }
                    )
                    .padding(.bottom, 30)
                    .shadow(color: Color.purple.opacity(0.5), radius: 10, x: 0, y: 5)

                    HStack {
                        Text("Don't have an account?")
                            .font(.system(size: 18, weight: .light, design: .rounded))
                            .opacity(0.8)
                            .foregroundColor(Color(red: 0.8, green: 0.8, blue: 1.0))
                            .frame(maxWidth: .infinity, alignment: .trailing)
                        Button {
                            shouldShowSignUpView = true
                        } label: {
                            Text("Sign up")
                                .underline()
                                .font(.system(size: 18, weight: .light, design: .rounded))
                                .opacity(0.8)
                                .foregroundColor(Color(red: 0.8, green: 0.8, blue: 1.0))
                        }
                        .foregroundStyle(.black)
                    }
                }
                .padding(.top, 15)
                Spacer()

            }
            .navigationBarBackButtonHidden(true)
            .navigationDestination(isPresented: $shouldShowSignUpView, destination: {
                RegisterView()
            })
            .onChange(of: viewModel.isSignedInSuccessfully) { _, newValue in
                if newValue {
                    appViewModel.completeSignIn()
                }
            }
            .onChange(of: viewModel.errorMessage) { _, newValue in
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
            
            
            if viewModel.isLoading {
                LoadingView(colors: [.purple, .indigo])
            }
        }
    }
}

#Preview {
    SignInView()
        .environmentObject(AppViewModel())
        .environmentObject(SignInViewModel())
}

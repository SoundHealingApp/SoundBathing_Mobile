//
//  SignInView.swift
//  SoundBathingApp
//
//  Created by Ирина Печик on 15.02.2025.
//

import SwiftUI

struct SignInView: View {
    @StateObject var viewModel = SignInViewModel()
    
    @State private var email = ""
    @State private var password = ""
    
    @State private var isEmailValid = true
    @State private var isPasswordValid = true
    
    @FocusState private var focusedField: FocusedField?
    @Environment(Router.self) var router
    @State private var showErrorToast = false

    private var isSignInButtonDisabled: Bool {
        !Validator.isEmailCorrect(email) || password.isEmpty
    }
    
    var body: some View {
        ZStack {
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
                
                Text("SIGN IN")
                    .font(customFont: .PlayfairDisplayMedium, size: 60)
                
                Text("To Sound Bathing")
                    .font(customFont: .FuturaPTLight, size: 25)
                    .foregroundStyle(Color.textGrayColor)
                    .padding(.bottom, 30)
                
                EmailTextField(email: $email, isEmailValid: $isEmailValid)
                
                PasswordTextField(password: $password, isFirstPasswordValid: $isPasswordValid)
                
                VStack(spacing: 20) {
                    SignInButtonView(isDisabled: isSignInButtonDisabled) {
                        Task {
                            await viewModel.sendSignInRequestAsync(email: email, password: password)
                        }
                    }
                    HStack {
                        Text("Don't have an account?")
                            .font(customFont: .FuturaPTLight, size: 20)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .foregroundStyle(Color(red: 79/255, green: 79/255, blue: 79/255))
                        Button {
                            router.navigateToSignUp()
                        } label: {
                            Text("Sign up")
                                .font(customFont: .FuturaPTLight, size: 20)
                                .bold()
                                .underline()
                        }
                        .foregroundStyle(.black)
                    }
                    .frame(width: 352)
                }
                .padding(.top, 15)
            }
            .onChange(of: viewModel.isSignedInSuccessfully) { _, newValue in
                if newValue {
                    router.navigateToSwiftUIView()
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
    SignInView()
}

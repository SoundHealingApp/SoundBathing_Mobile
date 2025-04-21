//
//  RegisterView.swift
//  SoundBathingApp
//
//  Created by Ирина Печик on 06.02.2025.
//

import SwiftUI

struct RegisterView: View {
    @EnvironmentObject var appViewModel: AppViewModel

    @StateObject var viewModel = CheckUserExistenceViewModel()
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var repeatedPassword: String = ""
    
    @State private var isEmailValid = true
    @State private var isFirstPasswordValid = true
    @State private var isRepeatedPasswordValid = true
    
    @State private var showErrorToast = false
    
    @FocusState private var focusedField: FocusedField?
    
    private var isNextButtonDisabled: Bool {
        !Validator.isEmailCorrect(email) ||
        !Validator.isPasswordCorrect(password: password) ||
        password != repeatedPassword
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
                
                Text("SIGN UP")
                    .font(customFont: .PlayfairDisplayMedium, size: 60)
                
                Text("And relax with SB App")
                    .font(customFont: .FuturaPTLight, size: 25)
                    .foregroundStyle(Color.textGrayColor)
                    .padding(.bottom, 30)
                
                EmailTextField(email: $email, isEmailValid: $isEmailValid)
                
                PasswordTextField(password: $password, isFirstPasswordValid: $isFirstPasswordValid)
                    .firstPasswordTFCustomStyle(password: $password, repeatedPassword: $repeatedPassword, isFirstPasswordValid: $isFirstPasswordValid, isRepeatedPasswordValid: $isRepeatedPasswordValid)
                
                SecureTextField(title: "Repeat password", text: $repeatedPassword)
                    .registrationTFCustomStyle()
                    .background(
                        RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/)
                            .stroke(!isRepeatedPasswordValid ? .red : focusedField == .repeatedPassword ? Color.blackAdaptive : Color.buttonGrayStroke, lineWidth: 1)
                    )
                    .focused($focusedField, equals: .repeatedPassword)
                    .onChange(of: repeatedPassword) {
                        isRepeatedPasswordValid =  Validator.isPasswordCorrect(password: repeatedPassword) && (password == repeatedPassword)
                        isFirstPasswordValid = Validator.isPasswordCorrect(password: password) && (password == repeatedPassword)
                    }
                    .padding(.bottom, isRepeatedPasswordValid ? 47 : 0)
                
                if !isRepeatedPasswordValid {
                    HStack {
                        Spacer()
                        Text((password != repeatedPassword) ? "The passwords don't match" : "")
                            .font(customFont: .OpenSansLight, size: 16)
                            .foregroundStyle(.red)
                            .padding(.trailing)
                    }
                    .frame(width: 352)
                    .padding(.bottom, 10)
                }
                
                CustomButtonView(text: "Next", isDisabled: isNextButtonDisabled) {
                    Task {
                        await viewModel.checkUserExistence(email: email, password: password)
                    }
                }
            }
            .onChange(of: viewModel.isCheckedSuccessful) { _, newValue in
                if newValue {
                    appViewModel.showNameEntering()
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
                            // TODO test: не нужно ли сбрасывать errorMessage тут?
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
    RegisterView()
}

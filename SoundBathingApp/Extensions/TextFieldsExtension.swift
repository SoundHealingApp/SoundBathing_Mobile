//
//  TextFieldsExtension.swift
//  SoundBathingApp
//
//  Created by Ирина Печик on 08.02.2025.
//

import SwiftUI


extension View {
    func registrationTFCustomStyle() -> some View {
        modifier(RegistrationTFViewModifier())
    }
    
    func firstPasswordTFCustomStyle(password: Binding<String>, repeatedPassword: Binding<String>, isFirstPasswordValid: Binding<Bool>, isRepeatedPasswordValid: Binding<Bool>) -> some View {
        modifier(FirstPasswordTFViewModifier(password: password, repeatedPassword: repeatedPassword, isFirstPasswordValid: isFirstPasswordValid, isRepeatedPasswordValid: isRepeatedPasswordValid))
    }
}

struct RegistrationTFViewModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .frame(width: 352, height: 63)
            .font(.custom("OpenSans-Light", size: 18))
            .foregroundStyle(Color.blackAdaptive)
    }
}


private struct FirstPasswordTFViewModifier: ViewModifier {
    @Binding var password: String
    @Binding var repeatedPassword: String
    @Binding var isFirstPasswordValid: Bool
    @Binding var isRepeatedPasswordValid: Bool
    func body(content: Content) -> some View {
        content
            .padding(.bottom, isFirstPasswordValid ? 47 : 0)
            .onChange(of: password) {
                if repeatedPassword.isEmpty {
                    isFirstPasswordValid = Validator.isPasswordCorrect(password: password)
                    // Хитрый ход
                    isRepeatedPasswordValid = true
                } else {
                    if password == repeatedPassword {
                        isFirstPasswordValid = Validator.isPasswordCorrect(password: password)
                    } else {
                        isFirstPasswordValid = false
                    }
                    // Хитрый ход
                    isRepeatedPasswordValid = Validator.isPasswordCorrect(password: repeatedPassword)
                }
            }
            if !isFirstPasswordValid {
                HStack {
                    Spacer()
                    Text(((!repeatedPassword.isEmpty) && (password != repeatedPassword)) ? "The passwords don't match" : "Password must be 6-20 chars with a number, uppercase and lowercase and at least one special character")
                        .font(.custom("OpenSans-Light", size: 16))
                        .foregroundStyle(.red)
                        .padding(.trailing)
                }
                .frame(width: 352)
                .padding(.bottom, 10)
            }
    }
}
 

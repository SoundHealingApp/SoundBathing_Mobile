//
//  EmailTextFieldView.swift
//  SoundBathingApp
//
//  Created by Ирина Печик on 09.02.2025.
//

import SwiftUI

struct EmailTextField: View {
    @Binding var email: String
    @Binding var isEmailValid: Bool
    
    @FocusState var focusedField: FocusedField?
    
    var body: some View {
        VStack {
            TextField("Enter your email", text: $email)
                .registrationTFCustomStyle()
                .background(
                    RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/)
                        .stroke(!isEmailValid ? .red : focusedField == .email
                                ? Color.blackAdaptive
                                : Color.buttonGrayStroke,
                            lineWidth: 1)
                )
                .focused($focusedField, equals: .email)
                .onChange(of: email) {
                    isEmailValid = Validator.isEmailCorrect(email)
                }
                .padding(.bottom, isEmailValid ? 47 : 0)
                .keyboardType(.emailAddress)
            
            if !isEmailValid {
                HStack {
                    Spacer()
                    Text("Your email is not valid")
                        .font(customFont: .OpenSansLight, size: 18)
                        .foregroundStyle(.red)
                        .padding(.trailing)
                }
                .frame(width: 352)
                .padding(.bottom, 10)
            }
        }
    }
}

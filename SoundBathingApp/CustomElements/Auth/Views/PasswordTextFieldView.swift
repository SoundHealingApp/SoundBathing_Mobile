//
//  PasswordTextFieldView.swift
//  SoundBathingApp
//
//  Created by Ирина Печик on 09.02.2025.
//

import SwiftUI

struct PasswordTextField: View {
    @Binding var password: String
    @Binding var isFirstPasswordValid: Bool
    
    @FocusState var focusedField: FocusedField?
    
    var body: some View {
        SecureTextField(title: "Enter password", text: $password)
            .registrationTFCustomStyle()
            .background(
                RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/)
                    .stroke(!isFirstPasswordValid ? .red : focusedField == .password ? Color.blackAdaptive : Color.buttonGrayStroke, lineWidth: 1)
            )
            .focused($focusedField, equals: .password)
    }
}

//
//  SecureTextFieldView.swift
//  SoundBathingApp
//
//  Created by Ирина Печик on 09.02.2025.
//

import SwiftUI

struct SecureTextField: View {
    @State private var isSecureField: Bool = true
    var title: String
    @Binding var text: String
        
    var body: some View {
        HStack {
            if isSecureField {
                SecureField(title, text: $text)
            } else {
                TextField(text, text: $text)
            }
        }.overlay(alignment: .trailing) {
            Image(systemName: isSecureField ? "eye.slash": "eye")
                .foregroundStyle(Color.blackAdaptive)
                .onTapGesture {
                    isSecureField.toggle()
                }
        }
    }
}

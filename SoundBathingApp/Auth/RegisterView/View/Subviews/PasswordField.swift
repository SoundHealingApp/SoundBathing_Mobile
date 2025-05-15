//
//  PasswordField.swift
//  SoundBathingApp
//
//  Created by Ирина Печик on 08.05.2025.
//

import SwiftUI

struct PasswordField: View {
    @Binding var password: String
    let placeholder: String
    let icon: String
    let validation: (String) -> Bool
    let onValidationChanged: (Bool) -> Void
    let showStrengthIndicator: Bool
    let otherPassword: String
    
    @State private var strength: PasswordStrength = .weak
    @State private var isEditing = false
    @State private var showPassword = false
    @FocusState private var isFocused: Bool
    @State private var showRequirements = false
    private let maxPasswordLength = 20
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(
                        isEditing ?
                            password.isEmpty ?
                                .white :
                                showStrengthIndicator ?
                                    strength.color :
                            ((!validation(password) || (!validation(password) && !otherPassword.isEmpty )) ? .red : .white) : .gray)
                    .scaleEffect(isEditing ? 1.1 : 1.0)
                
                ZStack(alignment: .leading) {
                    if password.isEmpty {
                        Text(placeholder)
                            .foregroundColor(.gray)
                            .transition(.opacity)
                    }
                    
                    if showPassword {
                        TextField("", text: $password)
                            .foregroundColor(.white)
                            .tint(.white)
                            .focused($isFocused)
                    } else {
                        SecureField("", text: $password)
                            .foregroundColor(.white)
                            .tint(.white)
                            .focused($isFocused)
                    }
                }
                
                if !password.isEmpty {
                    Button {
                        withAnimation {
                            showPassword.toggle()
                        }
                    } label: {
                        Image(systemName: showPassword ? "eye.fill" : "eye.slash.fill")
                            .foregroundColor(isEditing ? .white : .gray)
                    }
                    
                    Image(systemName: validation(password) ? "checkmark.circle.fill" : "xmark.circle.fill")
                        .symbolRenderingMode(.hierarchical)
                        .foregroundColor(validation(password) ? .green : .red)
                        .transition(.scale.combined(with: .opacity))
                }
            }
            .padding()
            .cornerRadius(15)
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(isEditing ? password.isEmpty ? .white : showStrengthIndicator ? strength.color : ((!validation(password) || (!validation(password) && !otherPassword.isEmpty )) ? .red : .white) : .gray, lineWidth: 1)
            )
            .onChange(of: password) {
                /// Показываем требования при вводе
                if !Validator.isPasswordCorrect(password: password) {
                    withAnimation {
                        showRequirements = true
                    }
                }
                updateValidation()
            }
            .onChange(of: isFocused) {
                withAnimation(.spring()) {
                    isEditing = isFocused
                }
            }
            
            /// Дополнительная информация
            if !password.isEmpty {
                if showStrengthIndicator && showRequirements {
                    /// Для основного поля пароля
                    VStack(alignment: .leading, spacing: 6) {
                        PasswordStrengthView(strength: $strength)
                        
                        HStack {
                            Text("\(password.count)/\(maxPasswordLength)")
                                .font(.caption)
                                .foregroundColor(password.count == maxPasswordLength ? .red : .gray)
                            
                            if password.count == maxPasswordLength {
                                Text("Max length reached")
                                    .font(.caption)
                                    .foregroundColor(.red)
                            }
                        }
                        
                        PasswordRequirementsView(password: password)
                    }
                    .padding(.horizontal)
                    .transition(.opacity.combined(with: .slide))
                    .onChange(of: Validator.isPasswordCorrect(password: password)) { _, isValid in
                        if isValid {
                            /// Плавно скрываем требования после небольшой задержки
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                withAnimation(.easeOut(duration: 0.3)) {
                                    showRequirements = false
                                }
                            }
                        }
                    }
                } else if !validation(password) && !otherPassword.isEmpty {
                    /// Для повторного пароля показываем ошибку только если оба пароля заполнены
                    Text("Passwords don't match")
                        .font(.caption)
                        .foregroundColor(.red)
                        .padding(.horizontal)
                }
            }
        }
    }
    
    private func updateValidation() {
        let newStrength = Validator.passwordStrengthBasedOnRequirements(password: password)
        withAnimation(.spring()) {
            strength = newStrength
        }
        onValidationChanged(validation(password))
    }
}

/// Компонент для отображения требований к паролю
struct PasswordRequirementsView: View {
    let password: String
    
    private var requirements: [Requirement] {
        [
            Requirement(text: "8+ characters", isMet: password.count >= 8),
            Requirement(text: "Uppercase letter", isMet: password.rangeOfCharacter(from: .uppercaseLetters) != nil),
            Requirement(text: "Number", isMet: password.rangeOfCharacter(from: .decimalDigits) != nil),
            Requirement(text: "Special character", isMet: password.rangeOfCharacter(from: CharacterSet(charactersIn: "!@#$%^&*()_-+={}[]|\\:;'<>,.?/~`")) != nil)
        ]
    }
    
    struct Requirement {
        let text: String
        let isMet: Bool
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            ForEach(requirements.indices, id: \.self) { index in
                HStack(spacing: 6) {
                    Image(systemName: requirements[index].isMet ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(requirements[index].isMet ? .green : .gray)
                        .font(.caption)
                    Text(requirements[index].text)
                        .font(.caption)
                        .foregroundColor(requirements[index].isMet ? .white : .gray)
                }
            }
        }
    }
}

#Preview {
    RegisterView()
}

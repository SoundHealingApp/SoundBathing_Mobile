//
//  PasswordStrengthField.swift
//  SoundBathingApp
//
//  Created by Ирина Печик on 07.05.2025.
//

import SwiftUI

struct PasswordStrengthField: View {
    @Binding var password: String
    let placeholder: String
    let onValidationChanged: (Bool) -> Void
    
    @State private var strength: PasswordStrength = .weak
    @State private var isEditing = false
    @State private var showPassword = false
    @FocusState private var isFocused: Bool
    
    private let maxPasswordLength = 20
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "lock.fill")
                    .foregroundColor(isEditing ? (strength.color) : .gray)
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
                            .onChange(of: password) { _, newValue in
                                if newValue.count > maxPasswordLength {
                                    password = String(newValue.prefix(maxPasswordLength))
                                }
                                updateStrength()
                            }
                    } else {
                        SecureField("", text: $password)
                            .foregroundColor(.white)
                            .tint(.white)
                            .focused($isFocused)
                            .onChange(of: password) { _, newValue in
                                if newValue.count > maxPasswordLength {
                                    password = String(newValue.prefix(maxPasswordLength))
                                }
                                updateStrength()
                            }
                    }
                }
                
                if !password.isEmpty {
                    Button {
                        withAnimation {
                            showPassword.toggle()
                        }
                    } label: {
                        Image(systemName: showPassword ? "eye.fill" : "eye.slash.fill")
                            .foregroundColor(.gray)
                    }
                    
                    PasswordStrengthIndicator(strength: strength)
                }
            }
            .padding()
            .cornerRadius(15)
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(isEditing ? strength.color : .gray, lineWidth: 1)
            )
            .onChange(of: isFocused) { _, newValue in
                withAnimation(.spring()) {
                    isEditing = newValue
                }
            }
            
            if !password.isEmpty {
                VStack(alignment: .leading, spacing: 4) {
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
                }
                .padding(.horizontal)
            }
        }
    }
    
    private func updateStrength() {
        let newStrength = Validator.passwordStrengthBasedOnRequirements(password: password)
        withAnimation(.spring()) {
            strength = newStrength
        }
        onValidationChanged(newStrength >= .medium)
    }
}

struct PasswordStrengthIndicator: View {
    let strength: PasswordStrength
    
    var body: some View {
        Text(strength.description)
            .font(.caption)
            .foregroundColor(strength.color)
            .padding(5)
            .background(strength.color.opacity(0.2))
            .cornerRadius(5)
    }
}

struct PasswordStrengthView: View {
    @Binding var strength: PasswordStrength
    
    var body: some View {
        HStack {
            ForEach(0..<3) { index in
                RoundedRectangle(cornerRadius: 2)
                    .fill(index <= strength.rawValue ? strength.color : Color.gray.opacity(0.3))
                    .frame(height: 4)
            }
        }
    }
}

extension Validator {
    static func passwordStrengthBasedOnRequirements(password: String) -> PasswordStrength {
        let requirements = [
            password.count >= 8,
            password.range(of: "[A-Z]", options: .regularExpression) != nil,
            password.range(of: "[a-z]", options: .regularExpression) != nil,
            password.rangeOfCharacter(from: .decimalDigits) != nil,
            password.rangeOfCharacter(from: CharacterSet(charactersIn: "!@#$%^&*()_-+={}[]|\\:;'<>,.?/~`")) != nil
        ]
        
        let metRequirements = requirements.filter { $0 }.count
        
        switch metRequirements {
        case 0..<2: return .weak
        case 2..<4: return .medium
        case 4...: return .strong
        default: return .weak
        }
    }
}

enum PasswordStrength: Int, Comparable {
    case weak, medium, strong
    
    static func < (lhs: PasswordStrength, rhs: PasswordStrength) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
    
    var color: Color {
        switch self {
        case .weak: return .red
        case .medium: return .yellow
        case .strong: return .green
        }
    }
    
    var description: String {
        switch self {
        case .weak: return "Weak"
        case .medium: return "Medium"
        case .strong: return "Strong"
        }
    }
}

#Preview {
    RegisterView()
}


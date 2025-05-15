//
//  AnimatedTextField.swift
//  SoundBathingApp
//
//  Created by Ирина Печик on 07.05.2025.
//

import SwiftUI

struct NameTextField: View {
    @Binding var name: String
    let placeholder: String
    let validation: (String) -> Bool
    let onValidationChanged: (Bool) -> Void
    
    @State private var isValid = false
    @State private var isEditing = false
    @FocusState private var isFocused: Bool
    
    // Анимационные состояния
    @State private var iconScale: CGFloat = 1.0
    @State private var borderWidth: CGFloat = 1.0
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                /// Иконка с анимацией
                Image(systemName: "person.fill")
                    .symbolRenderingMode(.hierarchical)
                    .foregroundColor(iconColor)
                    .scaleEffect(iconScale)
                    .animation(.spring(response: 0.3, dampingFraction: 0.5), value: iconScale)
                
                /// Поле ввода с плейсхолдером
                ZStack(alignment: .leading) {
                    if name.isEmpty {
                        Text(placeholder)
                            .foregroundColor(.gray.opacity(0.7))
                            .transition(.opacity)
                    }
                    
                    TextField("", text: $name)
                        .foregroundColor(.white)
                        .tint(.white)
                        .focused($isFocused)
                        .textContentType(.name)
                        .disableAutocorrection(true)
                        .submitLabel(.done)
                }
                
                /// Индикатор валидации
                if !name.isEmpty {
                    validationIcon
                        .transition(.scale.combined(with: .opacity))
                }
            }
            .padding()
            .cornerRadius(15)
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(borderColor, lineWidth: borderWidth)
            )
            .onChange(of: name) {
                validateName()
            }
            .onChange(of: isFocused) {
                withAnimation(.spring()) {
                    isEditing = isFocused
                    updateIconState()
                }
            }
        }
    }
    
    // MARK: - Subviews
    private var validationIcon: some View {
        Image(systemName: isValid ? "checkmark.circle.fill" : "xmark.circle.fill")
            .symbolRenderingMode(.hierarchical)
            .foregroundColor(isValid ? .green : .red)
            .font(.system(size: 20))
    }
    
    // MARK: - Computed Properties
    private var iconColor: Color {
        if isEditing {
            return isValid ? .green : (name.isEmpty ? .white : .red)
        }
        return .gray
    }
    
    private var borderColor: Color {
        if isEditing {
            return isValid ? .green : (name.isEmpty ? .white : .red)
        }
        return .gray.opacity(0.7)
    }
    
    private var backgroundStyle: some View {
        Color.black.opacity(0.2)
            .overlay(
                LinearGradient(
                    gradient: Gradient(colors: [.clear, .white.opacity(0.05)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
    }
    
    // MARK: - Private Methods
    private func validateName() {
        let isValid = validation(name)
        withAnimation(.spring()) {
            self.isValid = isValid
            self.borderWidth = isValid ? 1.5 : 1.0
        }
        onValidationChanged(isValid)
    }
    
    private func updateIconState() {
        iconScale = isFocused ? 1.2 : 1.0
    }
}

// MARK: - Preview

#Preview {
    NameEnteringView()
}

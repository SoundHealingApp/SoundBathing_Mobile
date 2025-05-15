//
//  EmailField.swift
//  SoundBathingApp
//
//  Created by Ирина Печик on 08.05.2025.
//

import SwiftUI

struct EmailField: View {
    @Binding var email: String
    let placeholder: String
    let validation: (String) -> Bool
    let onValidationChanged: (Bool) -> Void
    
    @State private var isEditing = false
    @State private var showSuggestions = false
    @State private var emailSuggestions: [EmailSuggestion] = []
    @FocusState private var isFocused: Bool
    
    // Анимационные состояния
    @State private var suggestionOpacity: Double = 0
    @State private var suggestionOffset: CGFloat = 5
    
    private let commonDomains = [
        ("gmail.com", "Google", "envelope.fill"),
        ("yahoo.com", "Yahoo", "flame.fill"),
        ("outlook.com", "Microsoft", "m.circle.fill"),
        ("icloud.com", "Apple", "applelogo"),
        ("mail.ru", "Mail.ru", "envelope.open.fill"),
        ("yandex.ru", "Yandex", "y.circle.fill"),
        ("protonmail.com", "ProtonMail", "lock.fill"),
        ("hotmail.com", "Hotmail", "flame.fill")
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "envelope")
                    .foregroundColor(emailIconColor)
                    .scaleEffect(isEditing ? 1.1 : 1.0)
                
                ZStack(alignment: .leading) {
                    if email.isEmpty {
                        Text(placeholder)
                            .foregroundColor(.gray)
                            .transition(.opacity)
                    }
                    
                    TextField("", text: $email)
                        .foregroundColor(.white)
                        .tint(.white)
                        .focused($isFocused)
                        .keyboardType(.emailAddress)
                        .textContentType(.emailAddress)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .onChange(of: email) { _, _ in
                            processEmailInput(email)
                        }
                }
                
                validationIcon
            }
            .padding()
            .cornerRadius(15)
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(borderColor, lineWidth: 1)
            )
            .onChange(of: isFocused) {
                withAnimation(.spring()) {
                    isEditing = isFocused
                    updateSuggestionsVisibility()
                }
            }
            
            // Подсказки с полными email-адресами
            if showSuggestions && !emailSuggestions.isEmpty {
                suggestionsView
                    .opacity(suggestionOpacity)
                    .offset(y: suggestionOffset)
                    .onAppear {
                        withAnimation(.easeOut(duration: 0.2)) {
                            suggestionOpacity = 1
                            suggestionOffset = 0
                        }
                    }
                    .onDisappear {
                        suggestionOpacity = 0
                        suggestionOffset = 5
                    }
            }
            
            if !email.isEmpty && !validation(email) {
                Text(validationMessage)
                    .font(.caption)
                    .foregroundColor(.red)
                    .padding(.horizontal)
                    .transition(.opacity)
            }
        }
    }
    
    // MARK: - Subviews
    private var suggestionsView: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("SUGGESTED EMAILS")
                .font(.caption2)
                .foregroundColor(.gray)
                .padding(.horizontal, 8)
            
            ForEach(emailSuggestions.prefix(5), id: \.id) { suggestion in
                HStack {
                    Image(systemName: suggestion.icon)
                        .foregroundColor(.white.opacity(0.7))
                    
                    VStack(alignment: .leading, spacing: 2) {
                        // Основной текст - полный email
                        Text(suggestion.fullEmail)
                            .font(.subheadline)
                            .foregroundColor(.white)
                        
                        // Подпись - провайдер
                        Text(suggestion.provider)
                            .font(.caption2)
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                }
                .padding(10)
                .cornerRadius(10)
                .onTapGesture {
                    withAnimation(.easeInOut) {
                        applySuggestion(suggestion)
                    }
                }
                .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
        .padding(.top, 8)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground).opacity(0.2))
                .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 2)
        )
    }
    
    private var validationIcon: some View {
        Group {
            if !email.isEmpty {
                Image(systemName: validation(email) ? "checkmark.circle.fill" : "xmark.circle.fill")
                    .symbolRenderingMode(.hierarchical)
                    .foregroundColor(validation(email) ? .green : .red)
                    .transition(.scale.combined(with: .opacity))
            }
        }
    }
    
    // MARK: - Logic Methods
    private func processEmailInput(_ input: String) {
        let isValid = validation(input)
        onValidationChanged(isValid)
        
        if isValid {
            withAnimation {
                showSuggestions = false
            }
            return
        }
        
        /// Отображаем подсказки только если есть @
        if input.contains("@") {
            generateDomainSuggestions(for: input)
        } else {
            emailSuggestions = []
        }
        
        updateSuggestionsVisibility()
    }
    
    private func generateDomainSuggestions(for input: String) {
        let parts = input.split(separator: "@", maxSplits: 1)
        guard parts.count == 2 else {
            emailSuggestions = []
            return
        }
        
        let prefix = String(parts[0])
        let enteredDomainPart = String(parts[1]).lowercased()
        
        /// Фильтруем домены по введенной части
        let filtered = commonDomains.filter { domain in
            if enteredDomainPart.isEmpty {
                return true
            }
            return domain.0.lowercased().hasPrefix(enteredDomainPart)
        }
        
        emailSuggestions = filtered.map { domain in
            EmailSuggestion(
                id: UUID(),
                prefix: prefix,
                domain: domain.0,
                provider: domain.1,
                icon: domain.2
            )
        }
    }
    
    private func updateSuggestionsVisibility() {
        let shouldShow = isFocused && email.contains("@") && !validation(email)
        
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            showSuggestions = shouldShow
        }
    }
    
    private func applySuggestion(_ suggestion: EmailSuggestion) {
        withAnimation(.easeInOut(duration: 0.2)) {
            email = "\(suggestion.prefix)@\(suggestion.domain)"
            isFocused = false
            onValidationChanged(validation(email))
            showSuggestions = false
        }
    }
    
    // MARK: - Computed Properties
    private var emailIconColor: Color {
        if isEditing {
            return email.isEmpty ? .white : validation(email) ? .green : .red
        }
        return .gray
    }
    
    private var borderColor: Color {
        isEditing ? email.isEmpty ? .white : (validation(email) ? .green : .red) : .gray.opacity(0.7)
    }
    
    private var validationMessage: String {
        if email.isEmpty {
            return "Email cannot be empty"
        } else if !email.contains("@") {
            return "Email must contain @ symbol"
        } else if email.split(separator: "@").count > 2 {
            return "Email can contain only one @ symbol"
        } else {
            return "Please enter a valid email address"
        }
    }
}

struct EmailSuggestion: Identifiable {
    let id: UUID
    let prefix: String
    let domain: String
    let provider: String
    let icon: String
    
    var fullEmail: String {
        "\(prefix)@\(domain)"
    }
}

#Preview {
    RegisterView()
}

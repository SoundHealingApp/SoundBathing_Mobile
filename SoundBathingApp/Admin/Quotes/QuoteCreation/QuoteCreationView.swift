//
//  QuoteCreationView.swift
//  SoundBathingApp
//
//  Created by Ирина Печик on 08.04.2025.
//

import SwiftUI

struct QuoteCreationView: View {
    @EnvironmentObject var viewModel: QuotesViewModel
    @Environment(\.dismiss) var dismiss
    
    enum FlowStep {
        case author, text, done
    }
    
    @State private var step: FlowStep = .author
    @State private var author: String = ""
    @State private var text: String = ""
    @State private var animateElements = false
    @State private var isKeyboardVisible = false
    
    // TODO: точно надо?
    let editingQuote: Quote?
    
    init(quote: Quote? = nil) {
        self.editingQuote = quote
        _author = State(initialValue: quote?.author ?? "")
        _text = State(initialValue: quote?.text ?? "")
    }
    
    var body: some View {
        VStack(spacing: 0) {
            /// Счетик заполняемой страницы
            if step != .done {
                ProgressDots(currentStep: step == .author ? 0 : 1, totalSteps: 2)
                    .padding(.top, 24)
                    .padding(.bottom, 20)
                    .transition(.opacity)
            }
            
            /// Меняем страницу в зависимости от шага
            ZStack {
                switch step {
                case .author:
                    StepAuthorView(author: $author)
                        .transition(.asymmetric(
                            insertion: .move(edge: .leading),
                            removal: .move(edge: .trailing)
                        ))
                case .text:
                    StepTextView(text: $text)
                        .transition(.asymmetric(
                            insertion: .move(edge: .trailing),
                            removal: .move(edge: .leading)
                        ))
                case .done:
                    QuoteConfirmationView()
                        .transition(.scale.combined(with: .opacity))
                }
            }
            .frame(maxHeight: .infinity)
            .padding(.horizontal)
            
            /// Кнопки навигации между страницами
            if step != .done {
                HStack(spacing: 16) {
                    if step == .text {
                        SecondaryButton(title: "Back") {
                            withAnimation { step = .author }
                        }
                    }
                    PrimaryButton(
                        title: step == .author ? "Continue" : "Save",
                        isActive: isPrimaryButtonActive
                    ) {
                        handlePrimaryAction()
                    }
                    .disabled(!isPrimaryButtonActive)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, isKeyboardVisible ? 8 : 24)
                /// Анимация изменения зависящих от клавиатуры изменений
                .animation(.easeInOut(duration: 0.2), value: isKeyboardVisible)
            }
        }
        .onAppear {
            withAnimation(.spring()) {
                animateElements = true
            }
        }
        /// Срабатывает при ПОЯВЛЕНИИ клавиатуры
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)) { _ in
            isKeyboardVisible = true
        }
        /// Срабатывает при СКРЫТИИ клавиатуры
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { _ in
            isKeyboardVisible = false
        }
    }
    
    // MARK: - Helper Methods
    
    /// Активна лм кнопка.
    private var isPrimaryButtonActive: Bool {
        switch step {
        case .author: return !author.trimmingCharacters(in: .whitespaces).isEmpty
        case .text: return !text.trimmingCharacters(in: .whitespaces).isEmpty
        case .done: return false
        }
    }
    
    private func handlePrimaryAction() {
        switch step {
        case .author:
            withAnimation(.spring()) {
                step = .text
            }
            
        case .text:
            let newQuote = Quote(author: author, text: text)
            
            if let existing = editingQuote {
                var updated = existing
                updated.author = author
                updated.text = text
                viewModel.updateQuote(updated)
            } else {
                viewModel.addQuote(newQuote)
            }
            
            withAnimation(.spring()) {
                step = .done
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                dismiss()
            }
            
        case .done:
            dismiss()
        }
    }
}

#Preview {
    QuoteCreationView()
}

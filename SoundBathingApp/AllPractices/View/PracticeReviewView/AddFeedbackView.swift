//
//  AddFeedbackView.swift
//  SoundBathingApp
//
//  Created by Ирина Печик on 29.03.2025.
//

import SwiftUI

struct AddFeedbackView: View {
    enum FlowState {
        case rating
        case comment
        case completion
    }
    
    @State private var currentState: FlowState = .rating
    @State private var rating: Int = 0
    @State private var comment: String = ""
    @State private var animateElements = false
    @State private var starPulse = false
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            // Фон с градиентом
            LinearGradient(
                gradient: Gradient(colors: [Color(.systemBackground), Color(.secondarySystemBackground)]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Показываем индикатор только не на экране завершения
                if currentState != .completion {
                    ProgressDots(currentStep: currentState == .rating ? 0 : 1, totalSteps: 2)
                        .padding(.top, 28)
                        .padding(.bottom, 32)
                }
                
                // Основной контент в ZStack
                ZStack {
                    // Экран рейтинга
                    if currentState == .rating {
                        RatingView(rating: $rating, triggerPulse: $starPulse)
                            .transition(.opacity)
                    }
                    
                    // Экран комментария
                    if currentState == .comment {
                        CommentView(comment: $comment)
                            .transition(.opacity)
                    }
                    
                    // Экран подтверждения
                    if currentState == .completion {
                        FeedbackConfirmationView()
                            .transition(.opacity.combined(with: .scale))
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(Color(.systemBackground))
                    }
                }
                .frame(maxWidth: .infinity)
                .animation(.easeInOut(duration: 0.3), value: currentState)
                
                Spacer()
                
                // Управляющие кнопки
                HStack(spacing: 16) {
                    if currentState == .comment {
                        SecondaryButton(title: "Back") {
                            withAnimation(.spring()) {
                                currentState = .rating
                            }
                        }
                    }
                    
                    PrimaryButton(
                        title: currentState == .rating ? "Continue" : "Submit",
                        isActive: currentState == .comment || rating > 0
                    ) {
                        handlePrimaryAction()
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 24)
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.6)) {
                animateElements = true
            }
        }
    }
    
    private func handlePrimaryAction() {
        switch currentState {
        case .rating:
            withAnimation(.spring()) {
                currentState = .comment
            }
        case .comment:
            submitFeedback()
        case .completion:
            dismiss()
        }
    }
    
    private func submitFeedback() {
        // Сохранение отзыва
        withAnimation(.easeInOut) {
            currentState = .completion
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            dismiss()
        }
    }
}

// MARK: - Стили кнопок

struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}

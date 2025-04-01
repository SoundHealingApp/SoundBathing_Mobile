//
//  AddFeedbackView.swift
//  SoundBathingApp
//
//  Created by Ирина Печик on 29.03.2025.
//

import SwiftUI
// TODO: на все вью добавить сообщение об ошибке
/// Добавление и редактирование отзывов
struct FeedbackCreationView: View {
    // MARK: - Properties
    @State private var currentState: FlowState = .rating
    @State private var estimate: Int = 0
    @State private var comment: String = ""
    @State private var animateElements = false
    @State private var starPulse = false
    @State var shouldShowErrorToast: Bool = false
    
    @ObservedObject var viewModel: FeedbacksViewModel
    @Environment(\.dismiss) var dismiss
    
    var practiceId: String
    let editingFeedback: Feedback?
    
    // MARK: - Computed properties
    var isEditingMode: Bool {
        editingFeedback != nil
    }
    // MARK: - Initializer
    init(practiceId: String, editingFeedback: Feedback? = nil, viewModel: FeedbacksViewModel) {
        self.practiceId = practiceId
        self.editingFeedback = editingFeedback
        self.viewModel = viewModel
        
        _estimate = State(initialValue: editingFeedback?.estimate ?? 0)
        _comment = State(initialValue: editingFeedback?.comment ?? "")
    }
        
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
                if shouldShowErrorToast {
                    ErrorToastView(
                        message: viewModel.errorMessage ?? "Something went wrong",
                        icon: "exclamationmark.triangle.fill",
                        gradientColors: [Color.red.opacity(0.9), Color.orange.opacity(0.9)],
                        shadowColor: Color.black.opacity(0.2),
                        cornerRadius: 15,
                        shadowRadius: 10,
                        shadowOffset: CGSize(width: 0, height: 5)
                    )
                    .transition(.move(edge: .top).combined(with: .opacity))
                    .animation(.spring(response: 0.5, dampingFraction: 0.6, blendDuration: 0), value: shouldShowErrorToast)
                    .padding()
                }
                
                // Показываем индикатор только не на экране завершения
                if currentState != .completion {
                    ProgressDots(currentStep: currentState == .rating ? 0 : 1, totalSteps: 2)
                        .padding(.top, 28)
                        .padding(.bottom, 32)
                }
                
                ZStack {
                    // Экран рейтинга
                    if currentState == .rating {
                        RatingView(rating: $estimate, triggerPulse: $starPulse)
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
                    
                    if currentState != .completion {
                        PrimaryButton(
                            title: currentState == .rating ? "Continue" : "Submit",
                            isActive: currentState == .comment || estimate > 0
                        ) {
                            handlePrimaryAction()
                        }
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 24)
            }
        }
        .onChange(of: viewModel.errorMessage) { _, newValue in
            if newValue != nil {
                withAnimation {
                    shouldShowErrorToast = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    withAnimation {
                        self.shouldShowErrorToast = false
                        viewModel.errorMessage = nil
                    }
                }
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
        guard let userId = KeyChainManager.shared.getUserId() else {
            viewModel.errorMessage = "Something went wrong. Please re-authorise in the app."
            return
        }
        
        let feedback = AddFeedbackRequestDto(
            userId: userId,
            comment: comment,
            estimate: estimate)
    
        
        Task {
            if isEditingMode {
                let changeFeedbackRequestDto = ChangeFeedbackRequestDto(
                    comment: comment,
                    estimate: estimate
                )
                
                await viewModel.changeFeedback(
                    practiceId: practiceId,
                    userId: userId,
                    changeFeedbackRequest: changeFeedbackRequestDto)
                
            } else {
                await viewModel.addFeedback(
                    practiceId: practiceId,
                    feedback: feedback)
            }
            
            if viewModel.errorMessage == nil {
                withAnimation(.easeInOut) {
                    currentState = .completion
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    dismiss()
                }
            }
        }
    }
    
    private enum FlowState {
        case rating
        case comment
        case completion
    }
}

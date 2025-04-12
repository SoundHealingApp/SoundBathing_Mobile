//
//  LiveStreamCreationView.swift
//  SoundBathingApp
//
//  Created by Ирина Печик on 12.04.2025.
//

import SwiftUI

struct LiveStreamCreationView: View {
    @EnvironmentObject var viewModel: LiveStreamViewModel
    @Environment(\.dismiss) var dismiss
    
    enum FlowStep {
        case basicInfo, details, done
    }
    
    @State private var step: FlowStep = .basicInfo
    @State private var title: String = ""
    @State private var description: String = ""
    @State private var therapeuticPurpose: String = ""
    @State private var startDateTime = Date()
    @State private var youTubeUrl: String = ""
    @State private var animateElements = false
    @State private var isKeyboardVisible = false
    
    let editingStream: LiveStream?
    
    init(stream: LiveStream? = nil) {
        self.editingStream = stream
        _title = State(initialValue: stream?.title ?? "")
        _description = State(initialValue: stream?.description ?? "")
        _therapeuticPurpose = State(initialValue: stream?.therapeuticPurpose ?? "")
        _startDateTime = State(initialValue: stream?.startDateTime ?? Date())
        _youTubeUrl = State(initialValue: stream?.youTubeUrl ?? "")
    }
    
    var body: some View {
        VStack {
            if step != .done {
                ProgressDots(currentStep: step == .basicInfo ? 0 : 1, totalSteps: 2)
                    .padding(.top, 24)
                    .padding(.bottom, 20)
                    .transition(.opacity)
            }
            
            /// Шаги создания стрима.
            ZStack {
                switch step {
                case .basicInfo:
                    StepBasicInfoView(
                        title: $title,
                        description: $description,
                        youTubeUrl: $youTubeUrl
                    )
                    .transition(.asymmetric(
                        insertion: .move(edge: .leading),
                        removal: .move(edge: .trailing)
                    ))
                case .details:
                    StepDetailsView(
                        therapeuticPurpose: $therapeuticPurpose,
                        startDateTime: $startDateTime
                    )
                    .transition(.asymmetric(
                        insertion: .move(edge: .trailing),
                        removal: .move(edge: .leading)
                    ))
                case .done:
                    LiveStreamConfirmationView()
                        .transition(.scale.combined(with: .opacity))
                }
            }
            .frame(maxHeight: .infinity)
            .padding(.horizontal)
            
            /// Кнопки навигации.
            if step != .done {
                HStack(spacing: 16) {
                    if step == .details {
                        SecondaryButton(title: "Back") {
                            withAnimation { step = .basicInfo }
                        }
                    }
                    
                    PrimaryButton(
                        title: step == .basicInfo ? "Continue" : "Save",
                        isActive: isPrimaryButtonActive
                    ) {
                        Task {
                            await handlePrimaryAction()
                        }
                    }
                    .disabled(!isPrimaryButtonActive)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, isKeyboardVisible ? 8 : 24)
                .animation(.easeInOut(duration: 0.2), value: isKeyboardVisible)
            }
        }
        .onAppear {
            withAnimation(.spring()) {
                animateElements = true
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)) { _ in
            isKeyboardVisible = true
        }
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { _ in
            isKeyboardVisible = false
        }
    }
    
    private var isPrimaryButtonActive: Bool {
        switch step {
        case .basicInfo:
            return !title.trimmingCharacters(in: .whitespaces).isEmpty &&
                   !description.trimmingCharacters(in: .whitespaces).isEmpty &&
                   !youTubeUrl.trimmingCharacters(in: .whitespaces).isEmpty
        case .details:
            return true
        case .done:
            return false
        }
    }
    
    private func handlePrimaryAction() async {
        switch step {
        case .basicInfo:
            withAnimation(.spring()) {
                step = .details
            }
            
        case .details:
            if let existing = editingStream {
                var updated = existing
                updated.title = title
                updated.description = description
                updated.therapeuticPurpose = therapeuticPurpose
                updated.startDateTime = startDateTime
                updated.youTubeUrl = youTubeUrl
                
                viewModel.updateStream(updated)
    //                    await viewModel.updateStream(updatedStream: updated)
            } else {
                viewModel.addStream(
                    LiveStream(
                        id: UUID().uuidString,
                        title: title,
                        description: description,
                        therapeuticPurpose: therapeuticPurpose,
                        startDateTime: startDateTime,
                        youTubeUrl: youTubeUrl
                    )
                )
    //                    let createStreamRequest = CreateLiveStreamRequestDto(
    //                        title: title,
    //                        description: description,
    //                        therapeuticPurpose: therapeuticPurpose,
    //                        startDateTime: startDateTime,
    //                        youTubeUrl: youTubeUrl
    //                    )
    //                    await viewModel.addStream(createStreamRequest)
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
    LiveStreamCreationView()
}

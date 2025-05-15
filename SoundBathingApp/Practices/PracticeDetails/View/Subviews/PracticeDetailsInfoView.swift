//
//  DetailInfoView.swift
//  SoundBathingApp
//
//  Created by Ирина Печик on 28.03.2025.
//

import SwiftUI

struct PracticeDetailsInfoView: View {
    // MARK: - Properties
    @State private var showingReviewForm = false
    @State private var editingFeedback: Feedback?
    @State private var showingDeleteAlert = false
    @State private var showingAllReviews = false
    @State private var showPlayer = false
    
    @State private var feedbackToDelete: Feedback?
    @State private var maxHeight: CGFloat = 100

    @StateObject var feedbacksViewModel = FeedbacksViewModel()
    @EnvironmentObject var viewModel: GetPracticesViewModel
    @EnvironmentObject var userPermissionsVM: UserPermissionsViewModel
    
    @State private var audioLoadTask: Task<Void, Never>?
    @State private var audioData: Data?
    @State private var isAudioLoading = false
    @State private var userRequestedPlay = false
    @State private var isUserAdmin = false
    @State private var isLoadingPermissions = true

    let practice: Practice
    @EnvironmentObject var vm: PlayerViewModel

    // MARK: - Computed Properties
    private var currentUserId: String {
        guard let userId = KeyChainManager.shared.getUserId() else {
            feedbacksViewModel.errorMessage = "Something went wrong. Please re-authorise in the app."
            return ""
        }
        return userId
    }
    
    var userHasFeedback: Bool {
        feedbacksViewModel.feedbacks.contains { $0.id == currentUserId }
    }
    
    // MARK: - View
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            /// Терапевтическая цель + Частота
            HStack(alignment: .top) {
                
                /// Описание терапевтической цели
                VStack(alignment: .leading, spacing: 8) {
                    Text("Therapeutic Purpose")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(.secondary)
                    
                    Text(practice.therapeuticPurpose)
                        .font(.system(size: 18, weight: .semibold))
                }
                
                Spacer()
                
                /// Описание частоты (если она есть)
                if let frequency = practice.frequency {
                    VStack(alignment: .trailing, spacing: 8) {
                        Text("Frequency")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundStyle(.secondary)
                        
                        HStack(spacing: 6) {
                            Image(systemName: "waveform.path.ecg")
                            Text("\(String(format: "%.1f", frequency)) Hz")
                                .font(.system(size: 18, weight: .semibold))
                        }
                    }
                }
            }
            .padding(.bottom, 10)
            
            /// Описание
            VStack(alignment: .leading, spacing: 8) {
                Text("Description")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.secondary)
                
                Text(practice.description)
                    .font(.system(size: 16, weight: .regular))
                    .lineSpacing(6)
                    .fixedSize(horizontal: false, vertical: true)
            }
            
            /// Секция с отзывами
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text("Reviews")
                        .font(.system(size: 18, weight: .semibold))
                    
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .foregroundColor(.orange)
                        Text(String(format: "%.1f", feedbacksViewModel.averageRating))
                            .font(.system(size: 14, weight: .medium))
                        Text("(\(feedbacksViewModel.feedbacks.count))")
                            .font(.system(size: 14))
                            .foregroundColor(.secondary)
                    }
                    
                    if !isLoadingPermissions && !userHasFeedback && !isUserAdmin {
                        Button {
                            showingReviewForm = true
                        } label: {
                            Image(systemName: "plus.circle.fill")
                                .font(.system(size: 20))
                                .foregroundColor(.blue)
                        }
                    }
                    
                    Spacer()
                    
                    if !feedbacksViewModel.feedbacks.isEmpty {
                        Button("See All") {
                            showingAllReviews = true
                        }
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.blue)
                    }
                    
                }
                
                if feedbacksViewModel.feedbacks.isEmpty {
                    Text("No reviews yet. Be the first to share your experience!")
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.vertical, 20)
                } else {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 15) {
                            ForEach($feedbacksViewModel.feedbacks) { feedback in
                                FeedbackCard(
                                    feedback: feedback,
                                    onEdit: {
                                        editingFeedback = feedback.wrappedValue
                                    },
                                    onDelete: {
                                        feedbackToDelete = feedback.wrappedValue
                                        showingDeleteAlert = true
                                    }
                                )
                                .frame(height: maxHeight) // Все карточки одной высоты
                                .onPreferenceChange(CardSizePreferenceKey.self) { size in
                                    if size.height > maxHeight {
                                        maxHeight = size.height
                                    }
                                }
                            }
                        }
                        .padding(.vertical, 8)
                        .padding(.horizontal, 2)
                    }
                }
            }
            .padding(.top, 10)
            
            /// Кнопка "Listen"
            if vm.practiceId != practice.id {
                Button {
                    handleListenButtonTap()
                } label: {
                    HStack {
                        if isAudioLoading {
                            ProgressView()
                                .tint(.white)
                        } else {
                            Image(systemName: "play.fill") // Иконка кнопки
                            Text("Start Listening")
                                .font(.system(size: 18, weight: .semibold))
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .foregroundStyle(.white)
                    .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing))
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    .shadow(color: Color.blue.opacity(0.3), radius: 10, x: 0, y: 5)
                }
                .disabled(isAudioLoading)
                .padding(.top, 20)
            }
            
            Spacer()
                .frame(height: 100) // Высота таб-бара + дополнительный отступ
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 30)
        .onAppear {
            startBackgroundAudioLoading()
            Task {
                async let loadAdminStatus = isUserCanManagePractice()
                async let loadFeedbacks: () = feedbacksViewModel.getPracticeFeedBacks(practiceId: practice.id)
                
                // Параллельная загрузка
                isUserAdmin = await loadAdminStatus
                _ = await loadFeedbacks
                
                isLoadingPermissions = false
            }
        }
        .onDisappear {
            // Отменяем загрузку если пользователь ушел с экрана
            audioLoadTask?.cancel()
        }
        .sheet(isPresented: $showingReviewForm) {
            FeedbackCreationView(
                practiceId: practice.id,
                viewModel: feedbacksViewModel)
        }
        .sheet(item: $editingFeedback) { feedback in
            FeedbackCreationView(
                practiceId: practice.id,
                editingFeedback: feedback,
                viewModel: feedbacksViewModel
            )
        }
        .sheet(isPresented: $showingAllReviews) {
            AllFeedbacksView(
                feedbacks: $feedbacksViewModel.feedbacks,
                averageRating: feedbacksViewModel.averageRating,
                practice: practice,
                viewModel: feedbacksViewModel
            )
        }
        .alert("Delete Review", isPresented: $showingDeleteAlert, presenting: feedbackToDelete) { feedback in
            Button("Delete", role: .destructive) {
                Task {
                    await feedbacksViewModel.deleteFeedback(
                        practiceId: practice.id,
                        userId: currentUserId)
                }
            }
            Button("Cancel", role: .cancel) {}
        } message: { _ in
            Text("Are you sure you want to delete this review?")
        }
    }
    
    private func startBackgroundAudioLoading() {
        guard audioData == nil, audioLoadTask == nil else { return }
        
        audioLoadTask = Task {
            let audio = await viewModel.downloadPracticeAudio(practiceId: practice.id)
            
            await MainActor.run {
                audioData = audio
                isAudioLoading = false
                
                // Если пользователь нажал кнопку, переходим на PlayerView
                if userRequestedPlay {
                    vm.configure(with: practice, audio: audioData!)
                    vm.resetAndPlayNewAudio()
                    showPlayer = true
                    userRequestedPlay = false
                }
            }
        }
    }
    
    private func handleListenButtonTap() {
        if audioData != nil {
            // Аудио уже загружено - сразу открываем плеер
            showPlayer = true
            vm.configure(with: practice, audio: audioData!)
            vm.resetAndPlayNewAudio()
        } else {
            // Устанавливаем флаг, что пользователь хочет проиграть аудио
            userRequestedPlay = true
            isAudioLoading = true
            
            // Если задача еще не запущена (например, onAppear не сработал)
            if audioLoadTask == nil {
                startBackgroundAudioLoading()
            }
        }
    }
    
    private func isUserCanManagePractice() async -> Bool {
        await userPermissionsVM.CanCurrentUserManagePracticesAsync()
    }
}

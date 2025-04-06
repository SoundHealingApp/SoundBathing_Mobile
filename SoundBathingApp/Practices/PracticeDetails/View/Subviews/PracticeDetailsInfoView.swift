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
    
    let practice: Practice
    
    // MARK: - Computed Properties
    private var currentUserId: String {
        guard let userId = KeyChainManager.shared.getUserId() else {
            feedbacksViewModel.errorMessage = "Something went wrong. Please re-authorise in the app."
            return ""
        }
        return userId
    }
    
    private var isAdmin: Bool {
        // TODO: Реализовать проверку на администратора
        false
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
                    
                    if !userHasFeedback && !isAdmin {
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
        
            if !showPlayer {
                /// Кнопка "Listen"
                Button {
                    // TODO: добавить действие для прослушивания
                    showPlayer = true
                } label: {
                    HStack {
                        Image(systemName: "play.fill") // Иконка кнопки
                        Text("Start Listening")
                            .font(.system(size: 18, weight: .semibold))
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .foregroundStyle(.white)
                    .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing))
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    .shadow(color: Color.blue.opacity(0.3), radius: 10, x: 0, y: 5)
                }
                .padding(.top, 20)
            }
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 30)
        .navigationDestination(isPresented: $showPlayer, destination: {
            PlayerView(
                showFullPlayer: true, audio: .constant(practice.audio),
                image: .constant(practice.image),
                title: .constant(practice.title),
                therapeuticPurpose: .constant(practice.therapeuticPurpose),
                frequency: .constant("\(practice.frequency)")
            )
        })
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
        .onAppear {
            Task {
                await feedbacksViewModel.getPracticeFeedBacks(practiceId: practice.id)
            }
        }
    }
}


//#Preview {
//    PracticeDetailsInfoView(
//        practice: Practice(
//        id: "123",
//        title: "Walking Meditation: Gratitude in Motion",
//        description: "This post-drop-off walking meditation invites you to slow down and reconnect with gratitude as you walk. With each step, focus on your breath and the simple beauty of this moment — the privilege of guiding a young life and the calm that follows the morning rush. Let your senses ground you, your breath anchor you, and gratitude gently fill the space between each step.",
//        meditationType: .daily,
//        therapeuticPurpose: "for health",
//        image: UIImage(systemName: "lock.document.fill")!,
//        frequency: 3,
//        feedbacks: [
//            Feedback(id: "1", meditationId: "12", userName: "Irina", comment: "This meditation helped me reduce stress significantly after just a week of practice.", estimate: 5),
//            Feedback(id: "2", meditationId: "12", userName: "Irina", comment: "This meditation helped me reduce stress significantly after just a week of practice.", estimate: 5),
//            Feedback(id: "3", meditationId: "12", userName: "Irina", comment: "This meditation helped me reduce stress significantly after just a week of practice. This meditation helped me reduce stress significantly after just a week of practice", estimate: 5)],
//        isFavorite: false)
//    )
//}

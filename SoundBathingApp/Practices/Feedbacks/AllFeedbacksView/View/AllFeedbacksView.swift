//
//  AllFeedbacksView.swift
//  SoundBathingApp
//
//  Created by Ирина Печик on 01.04.2025.
//

import SwiftUI

struct AllFeedbacksView: View {
    @Binding var feedbacks: [Feedback]
    let averageRating: Double
    let practice: Practice
    
    @State private var editingFeedback: Feedback?
    @State private var showingDeleteAlert = false
    @State private var feedbackToDelete: Feedback?
    @ObservedObject var viewModel: FeedbacksViewModel

    /// Распределение оценок
    private var ratingDistribution: [Int: Int] {
        var distribution = [1: 0, 2: 0, 3: 0, 4: 0, 5: 0]
        
        feedbacks.forEach {
            distribution[$0.estimate]? += 1
        }
        
        return distribution
    }
    
    // MARK: - Computed Properties
    private var currentUserId: String {
        guard let userId = KeyChainManager.shared.getUserId() else {
            viewModel.errorMessage = "Something went wrong. Please re-authorise in the app."
            return ""
        }
        return userId
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Верхняя часть с рейтингом
                RatingHeaderView(
                    averageRating: averageRating,
                    totalReviews: feedbacks.count,
                    ratingDistribution: ratingDistribution
                )
                .frame(maxWidth: .infinity, alignment: .leading)
                
                // Заголовок отзывов
                Text("Feedbacks / \(feedbacks.count)")
                    .font(.system(size: 16, weight: .semibold))
                    .padding(.horizontal, 16)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 16)
                
                // Список отзывов
                LazyVStack(spacing: 16) {
                    ForEach(feedbacks) { feedback in
                        ModernFeedbackCard(
                            feedback: feedback,
                            onEdit: { editingFeedback = feedback },
                            onDelete: {
                                feedbackToDelete = feedback
                                showingDeleteAlert = true
                            })
                            .padding(.horizontal, 16)
                    }
                }
            }
            .padding(.vertical, 16)
        }
        .sheet(item: $editingFeedback) { feedback in
            FeedbackCreationView(
                practiceId: practice.id,
                editingFeedback: feedback,
                viewModel: viewModel
            )
        }
        .alert("Delete Review", isPresented: $showingDeleteAlert, presenting: feedbackToDelete) { feedback in
            Button("Delete", role: .destructive) {
                Task {
                    await viewModel.deleteFeedback(
                        practiceId: practice.id,
                        userId: currentUserId)
                }
            }
            Button("Cancel", role: .cancel) {}
        } message: { _ in
            Text("Are you sure you want to delete this review?")
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Feedbacks")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    RatingHeaderView(
        averageRating: 3.5,
        totalReviews: 2,
        ratingDistribution: [1: 0, 2: 1, 3: 0, 4: 0, 5: 1])
}

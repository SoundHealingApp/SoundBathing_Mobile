//
//  ReviewView.swift
//  SoundBathingApp
//
//  Created by Ирина Печик on 29.03.2025.
//

import SwiftUI

/// Карточка отзывка
struct FeedbackCard: View {
    @Binding var feedback: Feedback

    var onEdit: (() -> Void)? = nil
    var onDelete: (() -> Void)? = nil
    
    private let maxCardWidth: CGFloat = 280
    private let minCardHeight: CGFloat = 100
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header with user info and rating
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(feedback.userName)
                            .font(.system(size: 16, weight: .semibold))
                        
                        if feedback.id == KeyChainManager.shared.getUserId() {
                            Text("(You)")
                                .font(.system(size: 14))
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    HStack(spacing: 4) {
                        RatingStars(rating: Double(feedback.estimate), size: 14)
                    }
                }
                
                Spacer()

                if feedback.id == KeyChainManager.shared.getUserId() {
                    Menu {
                        Button(action: { onEdit?() }) {
                            Label("Edit", systemImage: "pencil")
                        }
                        Button(role: .destructive, action: { onDelete?() }) {
                            Label("Delete", systemImage: "trash")
                        }
                    } label: {
                        Image(systemName: "ellipsis")
                            .foregroundColor(.secondary)
                    }
                }
            }
            
            if let comment = feedback.comment, !comment.isEmpty {
                Text(comment)
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
            } else {
                Text("No comment")
                    .font(.system(size: 14))
                    .foregroundColor(.secondary.opacity(0.5))
                    .lineLimit(4)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding(16)
        .frame(width: maxCardWidth)
        .frame(minHeight: minCardHeight) // Минимальная высота
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
        .overlay(
            GeometryReader { geometry in
                Color.clear
                    .preference(key: CardSizePreferenceKey.self, value: geometry.size)
            }
        )
    }
}

// Для синхронизации размеров карточек
struct CardSizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}
//#Preview {
//    FeedbackCard(
//        feedback: Feedback(
//            id: "2",
//            meditationId: "MeditationId",
//            userName: "Irina",
//            comment: "This meditation helped me reduce stress significantly after just a week of practice This meditation helped me reduce stress significantly after just a week of practice..",
//            estimate: 4
//        )
//    )
//}

//
//  ReviewView.swift
//  SoundBathingApp
//
//  Created by Ирина Печик on 29.03.2025.
//

import SwiftUI

/// Карточка отзывка
struct FeedbackCard: View {
    let feedback: Feedback
    
    var isItCurrentUserFeedback: Bool {
        print(KeyChainManager.shared.getUserId()!)
        
        if feedback.id == KeyChainManager.shared.getUserId() {
            return true
        }
        return false
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                HStack {
                    Text("\(feedback.userName)")
                        .font(.system(size: 16, weight: .semibold))
                    
                    Text(isItCurrentUserFeedback ? "(You)" : "")
                        .font(.system(size: 16, weight: .regular))
                }

                HStack {
                    HStack(spacing: 2) {
                        ForEach(1..<6) { star in
                            Image(systemName: star <= feedback.estimate ? "star.fill" : "star")
                                .foregroundStyle(.orange)
                                .font(.system(size: 12))
                        }
                    }
                }
            }
            
            if let comment = feedback.comment {
                Text(comment)
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
                    .lineLimit(6) // Ограничение текста для одинаковой высоты
                    .frame(maxHeight: .infinity, alignment: .top)
            }
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
    }
}

#Preview {
    FeedbackCard(
        feedback: Feedback(
            id: "2",
            meditationId: "MeditationId",
            userName: "Irina",
            comment: "This meditation helped me reduce stress significantly after just a week of practice.",
            estimate: 4
        )
    )
}

//
//  ModernFeedbackCard.swift
//  SoundBathingApp
//
//  Created by Ирина Печик on 02.04.2025.
//

import SwiftUI

// TODO: посмотреть, чем отличается от обычной feedbackcard
struct ModernFeedbackCard: View {
    let feedback: Feedback
    
    var onEdit: (() -> Void)? = nil
    var onDelete: (() -> Void)? = nil
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Заголовок
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
            
            // Текст отзыва
            if let comment = feedback.comment, !comment.isEmpty {
                Text(comment)
                    .font(.body)
                    .foregroundColor(.primary)
                    .lineSpacing(4)
            } else {
                Text("No comment provided")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .italic()
            }
        }
        .padding(16)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}

//#Preview {
//    ModernFeedbackCard()
//}

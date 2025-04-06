//
//  CommentView.swift
//  SoundBathingApp
//
//  Created by Ирина Печик on 29.03.2025.
//

import SwiftUI

struct CommentView: View {
    @Binding var comment: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Share your experience")
                .font(.system(size: 22, weight: .semibold))
                .padding(.bottom, 8)
            
            TextEditor(text: $comment)
                .frame(minHeight: 180)
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color(.tertiarySystemBackground))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.gray.opacity(0.1), lineWidth: 1)
                )
                .scrollContentBackground(.hidden)
            
            Text("Your feedback helps us improve")
                .font(.system(size: 14))
                .foregroundColor(.secondary)
                .frame(maxWidth: .infinity, alignment: .center)
        }
        .padding(.horizontal, 24)
    }
}

#Preview {
    CommentView(comment: .constant("comment"))
}

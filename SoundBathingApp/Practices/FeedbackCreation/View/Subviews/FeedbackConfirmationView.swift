//
//  FeedbackConfirmationView.swift
//  SoundBathingApp
//
//  Created by Ирина Печик on 29.03.2025.
//

import SwiftUI

struct FeedbackConfirmationView: View {
    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 60))
                .foregroundColor(.green)
            
            Text("Thank you for your feedback!")
                .font(.system(size: 22, weight: .semibold))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
    }
}

#Preview {
    FeedbackConfirmationView()
}

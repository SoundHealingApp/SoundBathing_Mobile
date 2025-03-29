//
//  RatingView.swift
//  SoundBathingApp
//
//  Created by Ирина Печик on 29.03.2025.
//

import SwiftUI

struct RatingView: View {
    @Binding var rating: Int
    @Binding var triggerPulse: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            Text("How would you rate this practice?")
                .font(.system(size: 22, weight: .semibold))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
                .padding(.bottom, 40)
            
            HStack(spacing: 16) {
                ForEach(1..<6) { star in
                    StarButton(
                        isFilled: star <= rating,
                        isPulsing: triggerPulse && star <= rating) {
                        withAnimation(.interactiveSpring()) {
                            rating = star
                        }
                        triggerPulse = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            triggerPulse = false
                        }
                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    }
                }
            }
            
            Text("Select 1-5 stars")
                .font(.system(size: 14))
                .foregroundColor(.secondary)
                .padding(.top, 24)
        }
    }
}

#Preview {
    RatingView(rating: .constant(3), triggerPulse: .constant(false))
}

//
//  QuoteConfirmationView.swift
//  SoundBathingApp
//
//  Created by Ирина Печик on 08.04.2025.
//

import SwiftUI

struct QuoteConfirmationView: View {
    @State private var isAnimating = false
    
    var body: some View {
        VStack(spacing: 24) {
            ZStack {
                Circle()
                    .fill(Color.purple.opacity(0.1))
                    .frame(width: 120, height: 120)
                    .scaleEffect(isAnimating ? 1.2 : 0.8)
                    .opacity(isAnimating ? 0 : 1)
                
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 60))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.purple, .indigo],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .symbolEffect(.bounce, value: isAnimating)
            }
            
            VStack(spacing: 8) {
                Text("Quote Saved!")
                    .font(.system(.title2, design: .rounded).bold())
                
                Text("Your inspirational quote has been added to the collection")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }
        }
        .padding()
        .onAppear {
            withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                isAnimating = true
            }
        }
    }
}

#Preview {
    QuoteConfirmationView()
}

//
//  DetailInfoView.swift
//  SoundBathingApp
//
//  Created by Ирина Печик on 28.03.2025.
//

import SwiftUI

struct DetailInfoView: View {
    
    let practice: Practice
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Text(practice.therapeuticPurpose)
                    .font(customFont: .GraphikMedium, size: 25)
                
                if (practice.frequency != nil) {
                    Spacer()
                    
                    Text(String(format: "%.2f HZ", practice.frequency!))
                        .font(customFont: .GraphikMedium, size: 25)
                }
            }
            
            Text(practice.description)
                .font(customFont: .GraphikRegular, size: 20)
                .fixedSize(horizontal: false, vertical: true)

            // TODO: добавить отзывы
            
            Button {
                // action
            } label: {
                Text("Listen")
                    .font(customFont: .GraphikMedium, size: 20)
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(.white)
                    .padding()
                    .background(.black)
                    .clipShape(Capsule())
                    .shadow(color: .black.opacity(0.3), radius: 10, x: 5, y: 8)
            }
        }
        .padding(.horizontal, 30)
    }
}


#Preview {
    DetailInfoView(
        practice: Practice(
        id: "123",
        title: "Walking Meditation: Gratitude in Motion",
        description: "This post-drop-off walking meditation invites you to slow down and reconnect with gratitude as you walk. With each step, focus on your breath and the simple beauty of this moment — the privilege of guiding a young life and the calm that follows the morning rush. Let your senses ground you, your breath anchor you, and gratitude gently fill the space between each step.",
        meditationType: .daily,
        therapeuticPurpose: "for health",
        image: UIImage(systemName: "lock.document.fill")!,
        frequency: nil,
        feedbacks: [],
        isFavorite: false)
    )
}

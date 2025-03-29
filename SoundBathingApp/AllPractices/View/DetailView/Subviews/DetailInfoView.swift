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
            
            /// Терапевтическая цель + Частота
            HStack {
                Text(practice.therapeuticPurpose)
                    .font(customFont: .GraphikMedium, size: 22)
                
                if let frequency = practice.frequency {
                    Spacer()
                    
                    HStack {
                        Image(systemName: "waveform.path.ecg")
                        
                        Text("\(String(format: "%.2f", frequency)) HZ")
                            .font(customFont: .GraphikMedium, size: 22)
                    }
                    .foregroundColor(.gray)
                }
            }
            
            /// Описание
            Text(practice.description)
                .font(customFont: .GraphikRegular, size: 18)
                .foregroundColor(.primary)
                .padding()
                .background(Color.gray.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .fixedSize(horizontal: false, vertical: true)

            // TODO: добавить отзывы
            
            /// Кнопка "Listen"
            Button {
                // TODO: добавить действие для прослушивания
            } label: {
                HStack {
                    Image(systemName: "play.fill") // Иконка кнопки
                    Text("Listen")
                        .font(customFont: .GraphikMedium, size: 20)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .foregroundColor(.white)
                .background(.black)
                .clipShape(Capsule())
                .shadow(color: .gray.opacity(0.3), radius: 10, x: 5, y: 8)
            }
        }
        .padding(.horizontal, 30)
        .padding(.top, 10)
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
        frequency: 3,
        feedbacks: [],
        isFavorite: false)
    )
}

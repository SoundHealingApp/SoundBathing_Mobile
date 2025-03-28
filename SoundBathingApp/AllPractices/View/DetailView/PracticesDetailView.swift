//
//  PracticesDetailView.swift
//  SoundBathingApp
//
//  Created by Ирина Печик on 27.03.2025.
//

import SwiftUI

struct PracticesDetailView: View {
    
    let practice: Practice

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 20) {
                ZStack(alignment: .bottomLeading) {
                    CardImageView(
                        image: practice.image,
                        width: UIScreen.main.bounds.width,
                        height: UIScreen.main.bounds.height / 3)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .shadow(color: .black.opacity(0.3), radius: 10, x: 5, y: 8)
                    
                    // Градиентный слой для читаемости текста
                    LinearGradient(
                        gradient: Gradient(colors: [Color.black.opacity(0.7), Color.clear]),
                        startPoint: .bottom,
                        endPoint: .top
                    )
                    .frame(height: 80)
                    
                    Text(practice.title)
                        .font(customFont: .GraphikMedium, size: 30)
                        .foregroundStyle(.white)
                        .fixedSize(horizontal: false, vertical: true)
                        .lineLimit(2)
                        .padding(.leading, 20)
                        .padding(.bottom, 10)
                }
                .frame(maxWidth: .infinity)
                
                DetailInfoView(practice: practice)
                
                Spacer()
            }
        }
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                BackButtonView() // TODO: рейтинг прямо в эту кнопку
            }
        }
    }
}

#Preview {
    PracticesDetailView(
        practice: Practice(
            id: "123",
            title: "Walking Meditation: Gratitude in Motion",
            description: "Amet sit efficitur integer lorem libero, luctus cras ornare mattis amet, sed morbi molestie non in ornare vestibulum luctus mattis in et dui dui leo, dolor orci, sit efficitur non lectus amet, mattis Amet sit efficitur integer lorem libero, luctus cras ornare mattis amet, sed morbi molestie non in ornare vestibulum luctus mattis in et dui dui leo, dolor orci, sit efficitur non lectus amet, mattis",
            meditationType: .daily,
            therapeuticPurpose: "for health",
            image: UIImage(systemName: "lock.document.fill")!,
            frequency: 2.3,
            feedbacks: [],
            isFavorite: false
        )
    )
}

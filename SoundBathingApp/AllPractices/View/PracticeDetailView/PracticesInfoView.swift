//
//  PracticesDetailView.swift
//  SoundBathingApp
//
//  Created by Ирина Печик on 27.03.2025.
//

import SwiftUI

struct PracticesInfoView: View {
    @State private var animateHeart = false
    @StateObject var getPracticesViewModel: GetPracticesViewModel

    let practice: Practice

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 0) {
                /// Картинка с градиентом и заголовком.
                ZStack(alignment: .bottomLeading) {
                    CardImageView(
                        image: practice.image,
                        width: UIScreen.main.bounds.width,
                        height: UIScreen.main.bounds.height / 2.5)
                    .clipped()
                    
                   /// Градиентный слой для читаемости текста.
                    LinearGradient(
                        gradient: Gradient(colors: [.clear, .black.opacity(0.7)]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    
                    /// Краткое описание практики.
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            /// Заголовок на изображении
                            Text(practice.title)
                                .font(.system(size: 28, weight: .semibold, design: .default))
                                .foregroundStyle(.white)
                                .multilineTextAlignment(.leading)
                                .lineLimit(2)
                                .shadow(color: .black.opacity(0.5), radius: 3, x: 0, y: 2)
                            
                            Spacer()
                            
                            Button {
                                withAnimation(.interpolatingSpring(stiffness: 300, damping: 15)) {
                                    Task {
                                        await getPracticesViewModel.toggleLike(practiceId: practice.id)
                                    }
                                    animateHeart = true
                                }
                                
                                // Haptic feedback
                                let generator = UIImpactFeedbackGenerator(style: .heavy)
                                generator.impactOccurred()
                                
                                // Reset animation after delay
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    animateHeart = false
                                }
                                
                            } label: {
                                Image(systemName: practice.isFavorite ? "heart.fill" : "heart")
                                    .font(.system(size: 24))
                                    .foregroundColor(practice.isFavorite ? .red : .white)
                                    .padding(10)
                                    .background(Circle().fill(Color.black.opacity(0.3)))
                                    .scaleEffect(animateHeart ? 1.5 : 1.0)
                                    .opacity(animateHeart ? 0.8 : 1.0)
                            }
                        }
                        
                        Text(practice.meditationType.rawValue)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.white)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background(Capsule().fill(Color.white.opacity(0.3)))
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 40)

                }
                .frame(height: UIScreen.main.bounds.height / 2.5)
                .edgesIgnoringSafeArea(.top)
                
                /// Информация о практике + отзывы + кнопка прослушивания
                PracticeDetailsInfoView(practice: practice)
                    .padding(.top, 20)
                    .background(Color(.systemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
                    .offset(y: -25)
                    .shadow(color: Color.black.opacity(0.1), radius: 20, x: 0, y: -10)
            }
        }
        .background(Color(.secondarySystemBackground))
        .edgesIgnoringSafeArea(.top)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                BackButtonView()
                    .padding(.leading, 10)
            }
        }
    }
}

#Preview {
    PracticesInfoView(
        getPracticesViewModel: GetPracticesViewModel(), practice: Practice(
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

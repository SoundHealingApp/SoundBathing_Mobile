//
//  RecommendationsView.swift
//  SoundBathingApp
//
//  Created by Ирина Печик on 18.04.2025.
//

import SwiftUI

struct RecommendationsView: View {
    @EnvironmentObject var viewModel: GetPracticesViewModel

    @State private var selectedRecommendation: Practice?
    @State private var isLoadingButton = false
    @State private var selectedPracticeToPlay: Practice? = nil

    var selectedItems: [Practice] {
        viewModel.recommendedPractices
    }

    var body: some View {
        ZStack {
            DynamicBackground()
                .ignoresSafeArea()
                .blur(radius: 20)
            
            ScrollView {
                VStack(spacing: 24) {
                    VStack(spacing: 8) {
                        Text("Your Personalized")
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                        
                        Text("Recommendations")
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [Color(hex: "#6A11CB"), Color(hex: "#2575FC")],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                    }
                    .padding(.top, 40)
                    .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
                    
                    /// Стек карточек
                    VStack(spacing: 0) {
                        ForEach(selectedItems) { item in
                            RecommendationCard(
                                practice: item,
                                isSelected: selectedRecommendation?.id == item.id,
                                index: selectedItems.firstIndex(of: item) ?? 0,
                                total: selectedItems.count
                            )
                            .zIndex(Double(selectedItems.count - (selectedItems.firstIndex(of: item) ?? 0)))
                            .offset(y: selectedRecommendation?.id == item.id ? -10 : CGFloat(selectedItems.firstIndex(of: item) ?? 0) * 4)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 4)
                            .onTapGesture {
                                withAnimation(.spring()) {
                                    selectedRecommendation = item
                                }
                            }
                        }
                    }
                    .padding(.vertical, 20)
                    
                    if selectedRecommendation != nil {
                        Button(action: {
                            Task {
                                guard let selectedPractice = selectedRecommendation else { return }
                                isLoadingButton = true
                                
                                if let audio = await viewModel.loadAudioForPractice(id: selectedPractice.id) {
                                    await MainActor.run {
                                        var updatedPractice = selectedPractice
                                        updatedPractice.audio = audio
                                        selectedPracticeToPlay = updatedPractice
                                    }
                                }
                                
                                await MainActor.run {
                                    isLoadingButton = false
                                }
                            }
                        }) {
                            HStack(spacing: 12) {
                                if isLoadingButton {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: Color(hex: "#1A1C2A")))
                                } else {
                                    Text("Begin Session")
                                        .font(.system(size: 17, weight: .semibold, design: .rounded))
                                    
                                    Image(systemName: "play.fill")
                                }
                            }
                            .foregroundColor(Color(hex: "#1A1C2A"))
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(
                                Capsule()
                                    .fill(.white)
                                    .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
                            )
                            .padding(.horizontal, 40)
                        }
                        .disabled(isLoadingButton)
                        .buttonStyle(ScaleButtonStyle())
                    }
                }
                .padding(.bottom, 40)
            }
        }
        .navigationDestination(item: $selectedPracticeToPlay) { practice in
            if let audio = practice.audio {
                PlayerView(
                    showFullPlayer: true,
                    audio: .constant(audio),
                    image: .constant(practice.image),
                    title: .constant(practice.title),
                    therapeuticPurpose: .constant(practice.therapeuticPurpose),
                    frequency: .constant(practice.frequency != nil ? String(format: "%.1f Hz", practice.frequency!) : ""),
                    practiceId: .constant(practice.id)
                )
            }
        }
        .task {
            /// Запускаем фоновую аудио загрузку при появлении
            await viewModel.loadRecommendedPracticesAudio()
        }
    }
}


#Preview {
    MeditationSurveyView()
}


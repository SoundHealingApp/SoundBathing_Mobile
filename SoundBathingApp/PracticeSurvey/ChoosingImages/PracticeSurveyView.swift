//
//  PracticeSurveyView.swift
//  SoundBathingApp
//
//  Created by Ирина Печик on 17.04.2025.
//

import SwiftUI
import CoreMotion

struct MeditationSurveyView: View {
    @EnvironmentObject var practicesVM: GetPracticesViewModel
    @EnvironmentObject var appViewModel: AppViewModel

    @State private var showRecommendations = false
    @State private var activeCard: String? = nil
    @State private var backgroundOffset: CGSize = .zero

    /// Переменные для создания вибрации при нажатии на карточку.
    private let selectionFeedback = UISelectionFeedbackGenerator()
    private let impactFeedback = UIImpactFeedbackGenerator(style: .soft)

    var body: some View {
        NavigationStack {
            ZStack {
                /// Фон
                DynamicBackground()
                    .ignoresSafeArea()
                    .blur(radius: 20)
                
                VStack(spacing: 0) {
                    VStack(spacing: 12) {
                        Text("What resonates")
                            .font(.system(size: 32, weight: .bold, design: .rounded))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.white, Color(hex: "#E0E0E0")],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                        
                        Text("with you today?")
                            .font(.system(size: 32, weight: .bold, design: .rounded))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [Color(hex: "#6A11CB"), Color(hex: "#2575FC")],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                    }
                    .padding(.top, 40)
                    .padding(.bottom, 24)
                    .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
                    
                    /// Карточки с изображением праткик.
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.flexible(), spacing: 16), GridItem(.flexible())], spacing: 16) {
                            ForEach(practicesVM.practices) { practice in
                                PracticeSurveyCard(
                                    image: practice.image,
                                    isSelected:  practicesVM.recommendedPracticesIdsSet.contains(practice.id),
                                    isActive: activeCard == practice.id
                                )
                                .onTapGesture {
                                    impactFeedback.impactOccurred()
                                    withAnimation(.interactiveSpring(response: 0.3, dampingFraction: 0.6)) {
                                        toggleSelection(for: practice.id)
                                    }
                                }
                                .onLongPressGesture(minimumDuration: 0.1) {
                                    selectionFeedback.selectionChanged()
                                    withAnimation(.easeInOut(duration: 0.2)) {
                                        activeCard = practice.id
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 20)
                    }
                    
                    /// Кнопка просмотра рекомендаций.
                    if !practicesVM.recommendedPracticesIdsSet.isEmpty {
                        Button(action: {
                            /// Добавление в бд инфы о рекомендованных праткиках
                            Task {
                                await practicesVM.addPracticesToRecommended()
                            }
                            
                            impactFeedback.impactOccurred(intensity: 0.7)
                            withAnimation(.spring(response: 0.5, dampingFraction: 0.7, blendDuration: 0.5)) {
                                showRecommendations = true
                            }
                        }) {
                            HStack(spacing: 10) {
                                Text("View Recommendations")
                                    .font(.system(size: 17, weight: .semibold, design: .rounded))
                                
                                Image(systemName: "arrow.right")
                                    .symbolEffect(.bounce, value: showRecommendations)
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(
                                Capsule()
                                    .fill(.ultraThinMaterial)
                                    .overlay(
                                        Capsule()
                                            .stroke(.white.opacity(0.5), lineWidth: 1)
                                    )
                                    .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
                            )
                            .padding(.horizontal, 40)
                            .contentShape(Capsule())
                        }
                        .buttonStyle(ScaleButtonStyle())
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Skip") {
                        appViewModel.skipSurveyAndRecommendations()
                    }
                    .font(.system(size: 16, weight: .medium, design: .rounded))
                    .foregroundColor(.white.opacity(0.6))
                }
            }
            .navigationDestination(isPresented: $showRecommendations) {
                RecommendationsView()
            }
        }
    }

    private func toggleSelection(for id: String) {
        if practicesVM.recommendedPracticesIdsSet.contains(id) {
            practicesVM.recommendedPracticesIdsSet.remove(id)
        } else {
            practicesVM.recommendedPracticesIdsSet.insert(id)
        }
        activeCard = nil
    }
}

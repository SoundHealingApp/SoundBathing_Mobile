//
//  LikedPractices.swift
//  SoundBathingApp
//
//  Created by Ирина Печик on 24.02.2025.
//

import SwiftUI

struct LikedPracticesView: View {
    @EnvironmentObject var viewModel: GetPracticesViewModel
    @EnvironmentObject var appViewModel: AppViewModel

    @State private var showEmptyState = false
    @State private var isButtonPressed = false
    @State private var animateGlow = false

    var columns = Array(repeating: GridItem(.flexible(), spacing: 16), count: 2)

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            if viewModel.practices.filter({ $0.isFavorite }).isEmpty {
                VStack(spacing: 24) {
                    Image(systemName: "heart.slash.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.pink.opacity(0.7))
                        .shadow(color: .pink.opacity(0.2), radius: 5, x: 0, y: 2)

                    Text("No favorite practices yet")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.center)

                    Text("Listen to some practices and save your favorites here!")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)

                    Button(action: {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) {
                            isButtonPressed.toggle()
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            isButtonPressed.toggle()
                            appViewModel.navigate(to: .main)
                        }
                    }) {
                        Text("Explore Practices")
                            .fontWeight(.bold)
                            .padding(.vertical, 12)
                            .padding(.horizontal, 28)
                            .background(
                                RoundedRectangle(cornerRadius: 14)
                                    .fill(Color.indigo)
                                    .shadow(color: animateGlow ? Color.indigo.opacity(0.5) : Color.clear, radius: 10)
                            )
                            .foregroundColor(.white)
                            .scaleEffect(isButtonPressed ? 0.9 : 1.0)
                    }
                    .onAppear {
                        withAnimation(Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                            animateGlow.toggle()
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding()
                .opacity(showEmptyState ? 1 : 0)
                .animation(.easeInOut(duration: 0.6), value: showEmptyState)
                .onAppear {
                    showEmptyState = true
                }
                .frame(height: UIScreen.main.bounds.height * 0.8) // Центрирование
            } else {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(viewModel.practices.filter { $0.isFavorite }, id: \.id) { practice in
                        NavigationLink(
                            destination: PracticesInfoView(
                                getPracticesViewModel: viewModel,
                                practice: practice)) {
                            PreviewPracticeCell(viewModel: viewModel, sizeCoefficient: 0.45, practice: practice)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 16)
            }
        }
        .navigationTitle("Favorites")
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
    }
}

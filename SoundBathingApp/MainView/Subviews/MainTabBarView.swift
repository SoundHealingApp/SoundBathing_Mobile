//
//  CustomTabBar.swift
//  SoundBathingApp
//
//  Created by Ирина Печик on 06.04.2025.
//

import SwiftUI

struct MainTabBarView: View {
    @Binding var selectedTab: MainTapBar
    @EnvironmentObject var audioPlayer: PlayerViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            // Только если есть активная практика и не открыт полный плеер
            if audioPlayer.hasActivePractice && !audioPlayer.isShowingFullPlayer {
                MiniPlayerView()
                    .transition(.move(edge: .top).combined(with: .opacity))
            }
            
            HStack {
                Spacer()

                tabBarButton(
                    tab: .likedPractices,
                    iconName: selectedTab == .likedPractices ? "heart.fill" : "heart"
                )

                Spacer()

                tabBarButton(
                    tab: .allPractices,
                    iconName: "waveform"
                )

                Spacer()

                tabBarButton(
                    tab: .profile,
                    iconName: selectedTab == .profile ? "person.crop.circle.fill" : "person.crop.circle"
                )

                Spacer()
            }
            .frame(height: 50)
            .background(Color(.systemGroupedBackground))
        }
        .frame(maxWidth: .infinity)
        .background(Color(.systemGroupedBackground))
        .ignoresSafeArea(edges: .bottom)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: selectedTab)
    }
    
    @ViewBuilder
    private func tabBarButton(tab: MainTapBar, iconName: String) -> some View {
        Button {
            withAnimation {
                selectedTab = tab
            }
        } label: {
            VStack(spacing: 4) {
                Image(systemName: iconName)
                    .symbolEffect(.bounce, value: selectedTab == tab)
                    .font(.title2)
                    .fontWeight(.medium)

                if selectedTab == tab {
                    Circle()
                        .fill(Color.black)
                        .frame(width: 5, height: 5)
                }
            }
        }
        .tint(selectedTab == tab ? .black : .gray.opacity(0.7))
        .frame(width: 44, height: 44)
    }
}

#Preview {
    MainTabBarView(selectedTab: .constant(.allPractices))
        .environmentObject(PlayerViewModel.shared)
}

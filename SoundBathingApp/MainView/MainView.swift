//
//  MainView.swift
//  SoundBathingApp
//
//  Created by Ирина Печик on 06.04.2025.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var practicesVM: GetPracticesViewModel
    @EnvironmentObject var playerVM: PlayerViewModel
    @EnvironmentObject var appViewModel: AppViewModel
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Group {
                switch appViewModel.selectedTab {
                case .allPractices:
                    NavigationStack {
                        PracticesView()
                    }
                case .likedPractices:
                    NavigationStack {
                        LikedPracticesView()
                    }
                case .profile:
                    NavigationStack {
                        ProfileView()
                    }
                }
            }

            if playerVM.isShowingFullPlayer {
                PlayerView(showHiddenButton: true)
                    .zIndex(3)
            }
            
            MainTabBarView(selectedTab: $appViewModel.selectedTab)
                .zIndex(2)
        }
        .background(Color(.systemGroupedBackground))
    }
}

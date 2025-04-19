//
//  MainView.swift
//  SoundBathingApp
//
//  Created by Ирина Печик on 06.04.2025.
//

import SwiftUI

struct MainView: View {
    @State var selectedTab: MainTapBar = .allPractices
    @EnvironmentObject var practicesVM: GetPracticesViewModel
//    @StateObject var getPracticesViewModel = GetPracticesViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                Group {
                    switch selectedTab {
                    case .allPractices:
                        PracticesView()
                    case .likedPractices:
                        LikedPracticesView()
                    case .profile:
                        ProfileView()
                    }
                }
                MainTabBarView(selectedTab: $selectedTab)
            }
        }
    }
}

#Preview {
    MainView()
}

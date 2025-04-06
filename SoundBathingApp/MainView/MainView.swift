//
//  MainView.swift
//  SoundBathingApp
//
//  Created by Ирина Печик on 06.04.2025.
//

import SwiftUI

// TODO: логика отображения функционала для администратора
struct MainView: View {
    @State var selectedTab: MainTapBar = .allPractices
    @StateObject var getPracticesViewModel = GetPracticesViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                Group {
                    switch selectedTab {
                    case .allPractices:
                        PracticesView(viewModel: getPracticesViewModel)
                    case .likedPractices:
                        LikedPracticesView(viewModel: getPracticesViewModel)
                    case .profile:
                        PersonalInformationView()
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

//
//  CustomTabBar.swift
//  SoundBathingApp
//
//  Created by Ирина Печик on 06.04.2025.
//

import SwiftUI

struct MainTabBarView: View {
    @Binding var selectedTab: MainTapBar
    
    var body: some View {
        HStack(alignment: .center, spacing: 60) {
            Button {
                selectedTab = .likedPractices
            } label: {
                Image(systemName: "heart.fill")
                    .font(.title2)
            }
            .tint(selectedTab == .likedPractices ? .black : .gray)

            Button {
                selectedTab = .allPractices
            } label: {
                Image(systemName: "waveform.path.ecg")
                    .font(.title2)
            }
            .tint(selectedTab == .allPractices ? .black : .gray)
            
            Button {
                selectedTab = .profile
            } label: {
                Image(systemName: "person.crop.circle")
                    .font(.title2)
            }
            .tint(selectedTab == .profile ? .black : .gray)
        }
    }
}

#Preview {
    MainTabBarView(selectedTab: .constant(.allPractices))
}

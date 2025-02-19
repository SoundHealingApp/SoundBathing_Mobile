//
//  TopBar.swift
//  SoundBathingApp
//
//  Created by Ирина Печик on 18.02.2025.
//

import SwiftUI

struct PracticesTopBar: View {
    @Binding var selectedTopBar: MeditationCategory
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 12) {
                Button {
                    selectedTopBar = .daily
                } label: {
                    HStack {
                        Image(systemName: "apple.meditate")
                        VStack(alignment: .leading) {
                            Text("Guided daily")
                                .font(.custom("Lora-Regular", size: 15))
                            Text("moments")
                                .font(.custom("Lora-Regular", size: 15))
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .frame(height: 48)
                    .overlay(
                        RoundedRectangle(cornerRadius: 40)
                            .stroke(selectedTopBar == .daily ? .black : .gray, lineWidth: 1)
                    )
                    .foregroundColor(selectedTopBar == .daily ? .black : .gray)
                    .cornerRadius(40)
                    .fixedSize(horizontal: false, vertical: true) // Фиксированный размер по вертикали
                }
                
                Button {
                    selectedTopBar = .restorative
                } label: {
                    HStack {
                        Image(systemName: "brain.head.profile")
                        VStack(alignment: .leading) {
                            Text("Restorative")
                                .font(.custom("Lora-Regular", size: 15))
                            Text("Sound Bath")
                                .font(.custom("Lora-Regular", size: 15))
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8) // Уменьшенный вертикальный отступ
                    .frame(height: 48)
                    .overlay(
                        RoundedRectangle(cornerRadius: 40)
                            .stroke(selectedTopBar == .restorative ? .black : .gray, lineWidth: 1)
                    )
                    .foregroundColor(selectedTopBar == .restorative ? .black : .gray)
                    .cornerRadius(40)
                    .fixedSize(horizontal: false, vertical: true) // Фиксированный размер по вертикали
                }
            }
            .padding(.horizontal, 16) // Отступы по краям
        }
    }
}

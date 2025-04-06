//
//  UserPersonInformationCard.swift
//  SoundBathingApp
//
//  Created by Ирина Печик on 06.04.2025.
//

import SwiftUI

struct UserPersonInformationCard: View {
    @StateObject var vm = PersonalInformationViewModel()
    @State private var showProfileView = false
    
    var body: some View {
        Button(action: {
            showProfileView = true
        }) {
            HStack(spacing: 12) {
                // Аватарка с эмодзи
                Text(vm.selectedEmoji.isEmpty ? "👤" : vm.selectedEmoji)
                    .font(.system(size: 36))
                    .frame(width: 44, height: 44)
                    .background(Circle().fill(Color.gray.opacity(0.2)))
                
                // Имя и фамилия
                VStack(alignment: .leading, spacing: 2) {
                    Text(vm.name.isEmpty ? "Name" : vm.name)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.primary)
                    
                    Text(vm.surname.isEmpty ? "Surname" : vm.surname)
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                }
                
                Spacer()
            }
            .padding(12)
            .background(Color(.systemGroupedBackground))
            .cornerRadius(12)
        }
        .buttonStyle(PlainButtonStyle())
        .navigationDestination(isPresented: $showProfileView, destination: {
            PersonalInformationView(vm: vm)
        })
    }
}
#Preview {
    UserPersonInformationCard()
}

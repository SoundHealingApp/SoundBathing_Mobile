//
//  MindfulMomentsView.swift
//  SoundBathingApp
//
//  Created by Ирина Печик on 20.04.2025.
//

import SwiftUI

struct MindfulMomentsView: View {
    @State var primaryColor: Color = Color.white

    var body: some View {
        VStack(spacing: 40) {
            CustomIcon(systemName: "brain.head.profile",
                     gradient: [Color(#colorLiteral(red: 1, green: 0.8, blue: 0.9, alpha: 1)),
                               Color(#colorLiteral(red: 0.8, green: 0.4, blue: 0.96, alpha: 1))])
            
            VStack(spacing: 16) {
                Text("Mindful Moments")
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                
                Text("Cultivate presence in every moment")
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                    .opacity(0.8)
            }
            .foregroundColor(primaryColor)
            .multilineTextAlignment(.center)
            .padding(.horizontal, 40)
        }
    }
}

#Preview {
    MindfulMomentsView()
}

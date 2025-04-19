//
//  BeginJourneyView.swift
//  SoundBathingApp
//
//  Created by Ирина Печик on 20.04.2025.
//

import SwiftUI

struct BeginJourneyView: View {
    @EnvironmentObject var appViewModel: AppViewModel

    @State var primaryColor: Color = Color.white
    @State var accentColor: Color = Color(#colorLiteral(red: 0.5809736252, green: 0.6380921006, blue: 0.9672341943, alpha: 1))

    var body: some View {
        VStack(spacing: 40) {
            CustomIcon(systemName: "figure.mind.and.body",
                       gradient: [Color(#colorLiteral(red: 0.8, green: 0.96, blue: 0.5, alpha: 1)),
                                  Color(#colorLiteral(red: 0.4, green: 0.8, blue: 0.2, alpha: 1))])
            
            VStack(spacing: 16) {
                Text("Begin Journey")
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                
                Text("Start your mindfulness practice today")
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                    .opacity(0.8)
            }
            .foregroundColor(primaryColor)
            .multilineTextAlignment(.center)
            .padding(.horizontal, 40)
            
            Button(action: { appViewModel.completeOnboarding() }) {
                Text("Get Started")
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                    .foregroundColor(Color(#colorLiteral(red: 0.1, green: 0.12, blue: 0.2, alpha: 1)))
                    .padding(.vertical, 16)
                    .padding(.horizontal, 40)
                    .background(
                        Capsule()
                            .fill(accentColor)
                            .shadow(color: accentColor.opacity(0.5), radius: 10, y: 5)
                    )
            }
            .buttonStyle(ScaleButtonStyle())
            .padding(.top, 20)
            
        }
    }
}

#Preview {
    BeginJourneyView()
}

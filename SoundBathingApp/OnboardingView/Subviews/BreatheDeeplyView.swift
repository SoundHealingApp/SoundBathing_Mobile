//
//  BreatheDeeplyView.swift
//  SoundBathingApp
//
//  Created by Ирина Печик on 20.04.2025.
//

import SwiftUI

struct BreatheDeeplyView: View {
    @State var primaryColor: Color = Color.white

    var body: some View {
        VStack(spacing: 40) {
            BreathAnimationView()
                .frame(width: 200, height: 200)
            
            VStack(spacing: 16) {
                Text("Breathe Deeply")
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                
                Text("Sync with the rhythm of your breath")
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
    BreatheDeeplyView()
}

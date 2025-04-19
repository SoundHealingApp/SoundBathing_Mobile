//
//  FindPeaceView.swift
//  SoundBathingApp
//
//  Created by Ирина Печик on 20.04.2025.
//

import SwiftUI

struct FindPeaceView: View {
    @State var primaryColor: Color = Color.white
    
    var body: some View {
        VStack(spacing: 40) {
            CustomIcon(systemName: "moon.fill",
                     gradient: [Color(#colorLiteral(red: 0.8, green: 0.88, blue: 1, alpha: 1)),
                               Color(#colorLiteral(red: 0.38, green: 0.8, blue: 0.96, alpha: 1))])
            
            VStack(spacing: 16) {
                Text("Find Peace")
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                
                Text("Discover inner calm in our digital sanctuary")
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
    FindPeaceView()
}

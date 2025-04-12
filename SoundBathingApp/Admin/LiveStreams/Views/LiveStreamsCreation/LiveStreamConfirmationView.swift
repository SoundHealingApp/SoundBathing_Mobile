//
//  LiveStreamConfirmationViw.swift
//  SoundBathingApp
//
//  Created by Ирина Печик on 12.04.2025.
//

import SwiftUI

struct LiveStreamConfirmationView: View {
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(LinearGradient(
                        colors: [.purple.opacity(0.1), .indigo.opacity(0.1)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ))
                    .frame(width: 180, height: 180)
                
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 60))
                    .foregroundStyle(LinearGradient(
                        colors: [.purple, .indigo],
                        startPoint: .leading,
                        endPoint: .trailing
                    ))
            }
            
            
            Text("Stream Saved!")
                .font(.system(.title2, design: .rounded).bold())
                .foregroundColor(.primary)
            
            Spacer()
        }
    }
}

#Preview {
    LiveStreamConfirmationView()
}

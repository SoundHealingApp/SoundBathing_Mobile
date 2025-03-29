//
//  ProgressDots.swift
//  SoundBathingApp
//
//  Created by Ирина Печик on 29.03.2025.
//

import SwiftUI

struct ProgressDots: View {
    let currentStep: Int
    let totalSteps: Int
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<totalSteps, id: \.self) { step in
                Capsule()
                    .frame(width: step == currentStep ? 24 : 8, height: 8)
                    .foregroundColor(step == currentStep ? .blue : .gray.opacity(0.2))
                    .animation(.spring(), value: currentStep)
            }
        }
    }
}

#Preview {
    ProgressDots(currentStep: 1, totalSteps: 2)
}

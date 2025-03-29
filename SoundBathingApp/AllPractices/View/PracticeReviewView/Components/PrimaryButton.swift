//
//  PrimaryButton.swift
//  SoundBathingApp
//
//  Created by Ирина Печик on 29.03.2025.
//

import SwiftUI

struct PrimaryButton: View {
    let title: String
    var isActive: Bool = true
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 17, weight: .semibold))
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(isActive ? Color.blue : Color.gray.opacity(0.3))
                .foregroundColor(.white)
                .cornerRadius(14)
        }
        .disabled(!isActive)
        .buttonStyle(ScaleButtonStyle())
    }
}

#Preview {
    PrimaryButton(title: "title", action: {})
}

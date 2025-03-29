//
//  SecondaryButton.swift
//  SoundBathingApp
//
//  Created by Ирина Печик on 29.03.2025.
//

import SwiftUI

struct SecondaryButton: View {
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 17, weight: .medium))
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(Color(.tertiarySystemBackground))
                .foregroundColor(.primary)
                .cornerRadius(14)
        }
        .buttonStyle(ScaleButtonStyle())
    }
}

#Preview {
    SecondaryButton(title: "Title", action: {})
}

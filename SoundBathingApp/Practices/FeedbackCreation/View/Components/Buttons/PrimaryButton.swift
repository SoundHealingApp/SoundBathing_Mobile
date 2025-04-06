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
    var isLoading: Bool = false
    let action: () -> Void
    var body: some View {
       Button(action: action) {
           HStack {
               if isLoading {
                   ProgressView()
                       .tint(.white)
               } else {
                   Text(title)
                       .font(.system(size: 17, weight: .semibold))
               }
           }
           .frame(maxWidth: .infinity)
           .frame(height: 50)
           .background(isActive ? Color.blue : Color.gray.opacity(0.3))
           .foregroundColor(.white)
           .cornerRadius(12)
       }
       .disabled(!isActive || isLoading)
       .buttonStyle(ScaleButtonStyle())

   }
}

#Preview {
    PrimaryButton(title: "title", action: {})
}

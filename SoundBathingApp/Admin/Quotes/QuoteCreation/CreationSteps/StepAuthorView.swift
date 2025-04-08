//
//  StepAuthorView.swift
//  SoundBathingApp
//
//  Created by Ирина Печик on 08.04.2025.
//

import SwiftUI

struct StepAuthorView: View {
    @Binding var author: String
    @FocusState private var isFocused: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            /// Анимированная иконка
            HStack(spacing: 12) {
                Image(systemName: "person.fill")
                    .font(.title3)
                    .foregroundColor(.indigo)
                    .symbolEffect(.bounce, value: isFocused)
                
                Text("Who said it?")
                    .font(.system(.title2, design: .rounded).bold())
                    .foregroundColor(.primary)
            }
            .transition(.opacity)
            
            /// Поле ввода имени автора
            TextField("Author name", text: $author)
                .focused($isFocused)
                .font(.system(.body, design: .rounded))
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color(.tertiarySystemBackground))
                        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(isFocused ? Color.indigo.opacity(0.6) : Color.gray.opacity(0.1),
                               lineWidth: isFocused ? 2 : 1)
                )
                .submitLabel(.next)
                .animation(.easeInOut(duration: 0.2), value: isFocused)
        }
        .padding(.horizontal, 16)
        .frame(maxHeight: .infinity, alignment: .top)
    }
}

#Preview {
    StepAuthorView(author: .constant(""))
}

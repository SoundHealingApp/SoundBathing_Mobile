//
//  StepTextView.swift
//  SoundBathingApp
//
//  Created by Ирина Печик on 08.04.2025.
//

import SwiftUI

struct StepTextView: View {
    @Binding var text: String
    @FocusState private var isFocused: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            /// Анимированная иконка
            HStack(spacing: 12) {
                Image(systemName: "quote.bubble.fill")
                    .font(.title3)
                    .foregroundColor(.indigo)
                    .symbolEffect(.bounce, value: isFocused)
                
                Text("What did the author said?")
                    .font(.system(.title2, design: .rounded).bold())
                    .foregroundColor(.primary)
            }
            
            /// Поле для ввода цитаты
            TextEditor(text: $text)
                .focused($isFocused)
                .font(.system(.body, design: .rounded))
                .frame(minHeight: 180)
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
                .scrollContentBackground(.hidden)
                .submitLabel(.done)
                .animation(.easeInOut(duration: 0.2), value: isFocused)

            
            /// Счетчик символов
            Text("\(text.count)/280")
                .font(.caption)
                .foregroundColor(text.count > 280 ? .red : .secondary)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.trailing, 8)
        }
        .padding(.horizontal, 16)
        .frame(maxHeight: .infinity, alignment: .top)
    }
}

#Preview {
    StepTextView(text: .constant("text"))
}

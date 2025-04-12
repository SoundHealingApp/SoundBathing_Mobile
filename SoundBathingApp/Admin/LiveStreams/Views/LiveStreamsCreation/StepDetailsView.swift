//
//  StepDetailsView.swift
//  SoundBathingApp
//
//  Created by Ирина Печик on 12.04.2025.
//

import SwiftUI

struct StepDetailsView: View {
    @Binding var therapeuticPurpose: String
    @Binding var startDateTime: Date
    
    @FocusState private var isPurposeFocused: Bool

    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                /// Поле с терапевтической целью.
                VStack(alignment: .leading, spacing: 8) {
                    HStack(spacing: 12) {
                        Image(systemName: "heart.text.square.fill")
                            .font(.title3)
                            .foregroundColor(.indigo)
                            .symbolEffect(.bounce, value: isPurposeFocused)
                        
                        Text("Therapeutic Purpose")
                            .font(.system(.title2, design: .rounded).bold())
                            .foregroundColor(.primary)
                    }
                    
                    TextEditor(text: $therapeuticPurpose)
                        .focused($isPurposeFocused)
                        .font(.system(.body, design: .rounded))
                        .frame(minHeight: 100)
                        .padding(16)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color(.tertiarySystemBackground))
                                .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(isPurposeFocused ? Color.indigo.opacity(0.6) : Color.gray.opacity(0.1),
                                       lineWidth: isPurposeFocused ? 2 : 1)
                        )
                        .scrollContentBackground(.hidden)
                        .submitLabel(.next)
                    
                    Text("\(therapeuticPurpose.count)/300")
                        .font(.caption)
                        .foregroundColor(therapeuticPurpose.count > 300 ? .red : .secondary)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .padding(.trailing, 8)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    HStack(spacing: 12) {
                        Image(systemName: "calendar.badge.clock")
                            .font(.title3)
                            .foregroundColor(.indigo)
                        
                        Text("Date & Time")
                            .font(.system(.title2, design: .rounded).bold())
                            .foregroundColor(.primary)
                    }
                    
                    DatePicker(
                        "Start Time",
                        selection: $startDateTime,
                        in: Date()..., /// Только будущие даты
                        displayedComponents: [.date, .hourAndMinute]
                    )
                    .datePickerStyle(.graphical)
                    .accentColor(.indigo)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color(.tertiarySystemBackground))
                            .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
                    )
                    
                    /// Визуальное предупреждение, если выбрано ближайшее время
                    if isWithinNextHour {
                        HStack {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .foregroundColor(.orange)
                            Text("Please ensure you'll be ready to stream at this time")
                                .font(.caption)
                                .foregroundColor(.orange)
                        }
                        .padding(8)
                        .background(Color.orange.opacity(0.1))
                        .cornerRadius(8)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 20)
        }
    }
    
    private var isWithinNextHour: Bool {
        let oneHourLater = Calendar.current.date(byAdding: .hour, value: 1, to: Date()) ?? Date()
        return startDateTime < oneHourLater
    }
}

#Preview {
    StepDetailsView(
        therapeuticPurpose: .constant("therapeuticPurpose"),
        startDateTime: .constant(Date.now)
    )
}

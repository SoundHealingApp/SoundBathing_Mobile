//
//  BirthDateView.swift
//  SoundBathingApp
//
//  Created by Ирина Печик on 14.02.2025.
//

import SwiftUI

struct BirthDateView: View {
    @Binding var date: Date
    
    let startDate = Calendar.current.date(from: DateComponents(year: 1900, month: 1, day: 1)) ?? Date()
    let endDate = Calendar.current.date(from: DateComponents(year: Calendar.current.component(.year, from: Date()), month: 12, day: 31)) ?? Date()

    var body: some View {
        DatePicker("", selection: $date, in: startDate...endDate,displayedComponents: .date)
            .scaleEffect(1.2)
            .datePickerStyle(.wheel)
            .frame(width: 100, height: 100, alignment: .center)
    }
}

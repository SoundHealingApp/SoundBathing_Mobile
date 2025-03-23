//
//  SectionHeader.swift
//  SoundBathingApp
//
//  Created by Ирина Печик on 23.03.2025.
//

import SwiftUI

// TODO: изменить шрифт

/// Заголовок для секции
struct SectionHeader: View {
    let title: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.title2)
                .bold()
            Spacer()
        }
        .padding(.horizontal)
    }
}

#Preview {
    PracticesView()
//    SectionHeader(title: "Title")
}

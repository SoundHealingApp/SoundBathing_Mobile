//
//  NameFieldView.swift
//  SoundBathingApp
//
//  Created by Ирина Печик on 14.02.2025.
//

import SwiftUI

struct NameFieldView: View {
    @Binding var name: String
    var placeholderName: String
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(placeholderName)
                .font(customFont: .MarcellusRegular, size: 15)
            TextField("", text: $name)
                .font(.custom(CustomFonts.MarcellusRegular.rawValue, size: 18))
                .frame(height: 35) // Высота текстового поля
                .overlay(
                    Rectangle().frame(height: 1),
                    alignment: .bottomLeading) // Нижняя линия
                .foregroundColor(.black) // Цвет текста
        }
        .frame(width: 320) // Ширина текстового поля
        .padding()
    }
}

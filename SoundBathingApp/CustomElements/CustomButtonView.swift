//
//  NextButtonView.swift
//  SoundBathingApp
//
//  Created by Ирина Печик on 13.02.2025.
//

import SwiftUI

public struct CustomButtonView: View {
    let text: String
    let isDisabled: Bool
    let action: () -> Void
    
    public var body: some View {
        Button(action: action, label: {
            Text(text)
                .foregroundStyle(Color.whiteAdaptive)
                .font(customFont: .MarcellusRegular, size: 20)
        })
        .frame(width: 352, height: 65)
        .background(Color.blackAdaptive)
        .opacity(isDisabled ? 0.6 : 1)

        .clipShape(RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/))
        .disabled(isDisabled)
    }
}

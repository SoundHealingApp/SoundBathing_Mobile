//
//  SignInButtonView.swift
//  SoundBathingApp
//
//  Created by Ирина Печик on 15.02.2025.
//

import SwiftUI

struct SignInButtonView: View {
    let isDisabled: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action, label: {
            Text("SIGN IN")
                .foregroundStyle(Color.whiteAdaptive)
                .font(customFont: .OpenSansRegular, size: 20)
        })
        .frame(width: 352, height: 65)
        .background(Color.blackAdaptive)
        .opacity(isDisabled ? 0.6 : 1)
        .clipShape(RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/))
        .disabled(isDisabled)
    }
}

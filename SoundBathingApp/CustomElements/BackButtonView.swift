//
//  BackButtonView.swift
//  SoundBathingApp
//
//  Created by Ирина Печик on 28.03.2025.
//

import SwiftUI

struct BackButtonView: View {
    @Environment(\.presentationMode)
    var presentationMode
    var body: some View {
        Button {
            self.presentationMode.wrappedValue.dismiss()
        } label: {
            Image(systemName: "chevron.backward")
                .foregroundStyle(.white)
            .font(.system(size: 20))
        }
    }
}

struct DarkBackButtonView: View {
    @Environment(\.presentationMode)
    var presentationMode
    var body: some View {
        Button {
            self.presentationMode.wrappedValue.dismiss()
        } label: {
            Image(systemName: "chevron.backward")
                .foregroundStyle(.black)
            .font(.system(size: 20))
        }
    }
}

#Preview {
    BackButtonView()
}

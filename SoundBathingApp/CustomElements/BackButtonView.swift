//
//  BackButtonView.swift
//  SoundBathingApp
//
//  Created by Ирина Печик on 28.03.2025.
//

import SwiftUI

//struct BackButtonView: View {
//    @Environment(\.dismiss) var dismiss
//    
//    var body: some View {
//        Button {
//            dismiss()
//        } label: {
//            ZStack {
//                Circle()
//                    .frame(width: 34)
//                    .foregroundStyle(.black)
//                    .opacity(0.3)
//                Image(systemName: "chevron.left")
//                    .font(.title3)
//                    .foregroundStyle(.white)
//                    .opacity(0.8)
//            }
//        }
//    }
//}

struct BackButtonView: View {
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

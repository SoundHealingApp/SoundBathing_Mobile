//
//  NameEnteringView.swift
//  SoundBathingApp
//
//  Created by Ирина Печик on 13.02.2025.
//

import SwiftUI

struct NameEnteringView: View {
    @EnvironmentObject var appViewModel: AppViewModel
    @StateObject var viewModel = NameEnteringViewModel()
    
    @State private var name: String = ""
    @State private var surname: String = ""
    @State private var presentNextView = false
    @State private var date: Date = Date.now

    var body: some View {
        VStack(alignment: .center, spacing: 40) {
            Text("Enter your name")
                .font(customFont: .LoraRegular, size: 32)
                .padding()
            VStack {
                NameFieldView(name: $name, placeholderName: "Name")
                NameFieldView(name: $surname, placeholderName: "Surname")
                    .padding(.top)
            }
            .padding()
            CustomButtonView(text: "Next", isDisabled: name.isEmpty || surname.isEmpty) {
                viewModel.saveNameDataToUserDefaults(name: name, surname: surname)
                appViewModel.showBirthEntering()
            }
            .padding(.top, 100)
        }
    }
}

#Preview {
    NameEnteringView()
}

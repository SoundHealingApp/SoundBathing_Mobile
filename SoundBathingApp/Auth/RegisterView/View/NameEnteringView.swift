//
//  NameEnteringView2.swift
//  SoundBathingApp
//
//  Created by Ирина Печик on 07.05.2025.
//

import SwiftUI

struct NameEnteringView: View {
    @EnvironmentObject var appViewModel: AppViewModel
    @StateObject var viewModel = NameEnteringViewModel()
    
    @State private var name: String = ""
    @State private var surname: String = ""
    @State private var showParticles = false
    
    let backgroundGradient = LinearGradient(
        gradient: Gradient(colors: [
            Color(#colorLiteral(red: 0.05, green: 0.06, blue: 0.1, alpha: 1)),
            Color(#colorLiteral(red: 0.1, green: 0.12, blue: 0.2, alpha: 1))
        ]),
        startPoint: .top,
        endPoint: .bottom
    )
    
    var body: some View {
        ZStack {
            backgroundGradient.ignoresSafeArea()
            
            VStack(spacing: 40) {
                Spacer()
                
                // Анимированный заголовок
                VStack(spacing: 10) {
                    Text("Tell Us About You")
                        .font(.system(size: 36, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .shadow(color: Color.purple.opacity(0.5), radius: 10, x: 0, y: 0)
                    
                    Text("We'd like to know you better")
                        .font(.system(size: 18, weight: .medium, design: .rounded))
                        .foregroundColor(Color(red: 0.8, green: 0.8, blue: 1.0))
                }
                
                // Поля ввода с анимацией
                VStack(spacing: 25) {
                    NameTextField(
                        name: $name,
                        placeholder: "First Name",
                        validation: { !$0.isEmpty },
                        onValidationChanged: { _ in }
                    )
                    .onChange(of: name) {
                        withAnimation {
                            showParticles = !name.isEmpty || !surname.isEmpty
                        }
                    }
                    
                    NameTextField(
                        name: $surname,
                        placeholder: "Last Name",
                        validation: { !$0.isEmpty },
                        onValidationChanged: { _ in }
                    )
                    .onChange(of: surname) {
                        withAnimation {
                            showParticles = !name.isEmpty || !surname.isEmpty
                        }
                    }
                }
                .padding(.horizontal, 20)
                
                Spacer()
                
                // Кнопка с эффектом нажатия
                GradientButton(
                    title: "Continue",
                    disabled: name.isEmpty || surname.isEmpty,
                    colors: [Color(red: 0.6, green: 0.2, blue: 1.0), Color(red: 0.4, green: 0.1, blue: 0.8)],
                    action: {
                        viewModel.saveNameDataToUserDefaults(name: name, surname: surname)
                        appViewModel.showBirthEntering()
                    }
                )
                .padding(.bottom, 30)
                .shadow(color: Color.purple.opacity(0.5), radius: 10, x: 0, y: 5)
            }
            .padding(.horizontal, 25)
        }
    }
}

#Preview {
    NameEnteringView()
}


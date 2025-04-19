//
//  SoundBathingAppApp.swift
//  SoundBathingApp
//
//  Created by Ирина Печик on 06.02.2025.
//

import SwiftUI

@main
struct SoundBathingAppApp: App {
//    @AppStorage("hasShownWelcome") var hasShownWelcome = false
//    @State private var showMainView = false
//    @State private var showSurveyView = false
    @StateObject private var practicesVM = GetPracticesViewModel()
    @StateObject private var appViewModel = AppViewModel()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appViewModel)
                .environmentObject(practicesVM)
                .onAppear {
                    // Загрузка данных при старте
                    Task {
                        await practicesVM.getAllPractices()
                    }
                }
//            MeditationSurveyView()
//            if showMainView {
//                MainView()
//            } else {
//                // TODO: Сделать тут потом метод, принимающий решение, какое вью отображать
//                WelcomeQuoteView(showMainView: $showMainView, showSurveyView: $showSurveyView)
//            }
//            ContentView()
//            if !hasShownWelcome {
//                WelcomeQuoteView()
//                    .onDisappear {
//                        hasShownWelcome = true
//                    }
//            } else {
//                MainView()
//                    .withRouter()
//            }
//             TODO: проверка на срок действия токена
//            if KeyChainManager.shared.getToken() != nil {
//                MainView()
//                    .withRouter()
//            } else {
//               SignInView()
//                    .withRouter()
//            }
//            
//            
//            CreateMeditationView()
//            SignInView()
//            BirthdateEnteringView()
//            RegisterView()
//            NameEnteringView()
        }
    }
}

//func f() {
//    for family in UIFont.familyNames.sorted() {
//        print("Family: \(family)")
//        
//        let fontNames = UIFont.fontNames(forFamilyName: family)
//        for fontName in fontNames {
//            print("    Font: \(fontName)")
//        }
//    }
//}

struct ContentView: View {
    @EnvironmentObject var appViewModel: AppViewModel
    @EnvironmentObject var practicesVM: GetPracticesViewModel

    var body: some View {
        Group {
            if appViewModel.showMainView {
                MainView()
            } else if appViewModel.showSurveyView {
                MeditationSurveyView()
            } else {
                WelcomeQuoteView(showMainView: $appViewModel.showMainView, showSurveyView: $appViewModel.showSurveyView)
            }
        }
    }
}

// TODO: сделать логику
class AppViewModel: ObservableObject {
    @Published var showMainView = false
    @Published var showSurveyView = false
    
    func checkOnboarding() {
        // Логика проверки необходимости онбординга
//        showMainView = UserDefaults.standard.bool(forKey: "hasCompletedOnboarding")
    }
}

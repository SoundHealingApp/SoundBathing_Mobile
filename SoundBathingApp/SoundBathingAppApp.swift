//
//  SoundBathingAppApp.swift
//  SoundBathingApp
//
//  Created by Ирина Печик on 06.02.2025.
//

import SwiftUI

@main
struct SoundBathingAppApp: App {
    var body: some Scene {
        WindowGroup {
            // TODO: проверка на срок действия токена
            if KeyChainManager.shared.getToken() != nil {
                MainView()
                    .withRouter()
            } else {
               SignInView()
                    .withRouter()
            }
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

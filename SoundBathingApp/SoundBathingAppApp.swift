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
            PracticesView()
//            CreateMeditationView()
//            SignInView()
//            BirthdateEnteringView()
//            RegisterView()
//            NameEnteringView()
                .withRouter()
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

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
//            OnboardingView()
            ContentView()
                .environmentObject(appViewModel)
                .environmentObject(practicesVM)
                .onAppear {
                    appViewModel.setupBackgroundTasks() // ← Здесь!

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
            if appViewModel.showOnboarding {
                OnboardingView()
            } else if appViewModel.showMainView {
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
    @Published var skipRecommendations = false
    @Published var showOnboarding = !UserDefaults.standard.bool(forKey: "completedOnboarding")
    
    private let surveyInterval: TimeInterval = 1 * 3600 // 5 часов в секундах
    
    init() {
        checkSurveyConditions()
    }
    
    private func checkInitialState() {
        // 1) Администтор или нет
        // 2) Зарегистрирован или нет
        // 3) Цитата
        // 4) Опрос
        // 5) Главное вью
    }
    
    /// Поставить признак законченного онбординга.
    func completeOnboarding() {
        UserDefaults.standard.set(true, forKey: "completedOnboarding")
        showOnboarding = false
        checkSurveyConditions()
    }
    
    /// Проверяем, когда в последний раз пользователю показывался опрос.
    func checkSurveyConditions() {
        let lastSurveyDate = UserDefaults.standard.object(forKey: "lastSurveyDate") as? Date ?? Date.distantPast
        let timeSinceLastSurvey = Date().timeIntervalSince(lastSurveyDate)
        
        // Если прошло больше 5 часов или это первый запуск
        if timeSinceLastSurvey > surveyInterval {
            showSurveyView = true
            showMainView = false
        } else {
            showMainView = true
            showSurveyView = false
        }
    }
    
    /// Установка фоновых задач.
    func setupBackgroundTasks() {
        setupDailyMeditationReminder()
    }
    
    /// Установка ежедневных напоминаний.
    private func setupDailyMeditationReminder() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, _ in
            if granted {
                self.scheduleDailyReminder()
                print("Разрешение на уведомления получено")
            }
        }
    }
    
    /// Настройка ежедневного напоминания.
    private func scheduleDailyReminder() {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: ["dailyMeditationReminder"])
        
        let content = UNMutableNotificationContent()
        content.title = "Mindful Reminder"
        content.body = "Time to meditate 🧘‍♂️"
        content.sound = .default
        
        /// Устанавливаем время ежеденевного уведомления ( 11:00 утра)
        var dateComponents = DateComponents()
        dateComponents.hour = 11
        dateComponents.minute = 00
        
        let trigger = UNCalendarNotificationTrigger(
            dateMatching: dateComponents,
            repeats: true
        )
        
        let request = UNNotificationRequest(
            identifier: "dailyMeditationReminder",
            content: content,
            trigger: trigger
        )
        
        center.add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            } else {
                print("Daily meditation reminder scheduled successfully")
            }
        }
    }
    
    func didCompleteSurvey() {
        // Сохраняем текущее время как время последнего опроса
        UserDefaults.standard.set(Date(), forKey: "lastSurveyDate")
        showSurveyView = false
        showMainView = true
    }
    
    func skipSurveyAndRecommendations() {
//        UserDefaults.standard.set(true, forKey: "skipRecommendations")
        skipRecommendations = true
        showSurveyView = false
        showMainView = true
    }


}

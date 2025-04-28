//
//  SoundBathingAppApp.swift
//  SoundBathingApp
//
//  Created by Ирина Печик on 06.02.2025.
//

import SwiftUI
import JWTDecode

@main
struct SoundBathingAppApp: App {
    @StateObject private var practicesVM = GetPracticesViewModel()
    @StateObject private var appViewModel = AppViewModel()
    @StateObject private var userPermissionsViewModel = UserPermissionsViewModel()
    @StateObject private var liveStreamViewModel = LiveStreamViewModel()
    @StateObject private var signInViewModel = SignInViewModel()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appViewModel)
                .environmentObject(practicesVM)
                .environmentObject(userPermissionsViewModel)
                .environmentObject(liveStreamViewModel)
                .environmentObject(signInViewModel)
                .onAppear {
                    appViewModel.setupBackgroundTasks()
                    
                    /// Загрузка данных при старте
                    Task {
                        await practicesVM.getAllPractices()
                    }
                }
        }
    }
}

struct ContentView: View {
    @EnvironmentObject var appViewModel: AppViewModel
    @EnvironmentObject var practicesVM: GetPracticesViewModel

    var body: some View {
        Group {
            NavigationStack(path: $appViewModel.navigationPath) {
                WelcomeQuoteView()
                    .navigationDestination(for: AppRoute.self) { route in
                        switch route {
                        case .onboarding:
                            OnboardingView()
                        case .register:
                            RegisterView()
                        case .survey:
                            MeditationSurveyView()
                        case .signIn:
                            SignInView()
                        case .nameEntering:
                            NameEnteringView()
                        case .birthEntering:
                            BirthdateEnteringView()
                        case .main:
                            MainView()
                        }
                    }
            }
        }
    }
}

enum AppRoute: Hashable {
    case onboarding
    case register
    case survey
    case signIn
    case nameEntering
    case birthEntering
    case main
}

@MainActor
class AppViewModel: ObservableObject {
    @Published var navigationPath = NavigationPath()
    @Published var showOnboarding = !UserDefaults.standard.bool(forKey: "completedOnboarding")
    @Published var showWelcomeQuote = true // Новое состояние для цитаты
    
    private let surveyInterval: TimeInterval = 5 * 3600 // 5 часов в секундах
    
    init() {
        checkInitialState()
    }
    
    private func checkInitialState() {
        showWelcomeQuote = true
    }
    
    /// Перейти на вью регистрации.
    func showSignUpViewFromSignIn() {
        navigate(to: .register)
    }
    
    func showNameEntering() {
        navigate(to: .nameEntering)
    }

    func showBirthEntering() {
        navigate(to: .birthEntering)
    }
    
    func hideWelcomeQuote() async {
        showWelcomeQuote = false
        
        if shouldRegister() {
            if !UserDefaults.standard.bool(forKey: "completedOnboarding") {
                navigate(to: .onboarding)
            } else {
                navigate(to: .signIn)
            }
        }
        else if await shouldSignIn() {
            navigate(to: .signIn)
        } else {
            checkSurveyConditions()
        }
    }
    
    /// Должен ли пользователь зарегистрироваться в системе
    func shouldRegister() -> Bool {
        /// Проверяем, зарегистрирован ли пользователь
        return !UserDefaultsManager.shared.isUserRegistered()

    }
    
    /// Должен ли пользователь войти в систему.
    func shouldSignIn() async -> Bool {
        guard let token = KeyChainManager.shared.getToken() else {
            /// Токена нет - нужно войти
            return true
        }
        
        guard let id = KeyChainManager.shared.getUserId() else {
            return true
        }
        
        let isUserExists = await checkUserExistence(id: id)

        if !isUserExists {
            return true
        }
        
        return isTokenExpired(token)
    }
    
    /// Поставить признак законченного онбординга.
    func completeOnboarding() {
        UserDefaults.standard.set(true, forKey: "completedOnboarding")
        navigate(to: .survey)
    }
    
    func completeSignUp() {
        navigationPath = NavigationPath()
        navigate(to: .main)
    }
    
    func completeSignIn() {
        navigationPath = NavigationPath()
        navigate(to: .survey)
    }
    
    /// Проверяем, когда в последний раз пользователю показывался опрос.
    func checkSurveyConditions() {
        let lastSurveyDate = UserDefaults.standard.object(forKey: "lastSurveyDate") as? Date ?? Date.distantPast
        let timeSinceLastSurvey = Date().timeIntervalSince(lastSurveyDate)
        
        // Если прошло больше 5 часов или это первый запуск
        if timeSinceLastSurvey > surveyInterval {
            navigate(to: .survey)
        } else {
            navigate(to: .main)
        }
    }
    
    /// Установка фоновых задач.
    func setupBackgroundTasks() {
        setupDailyMeditationReminder()
    }
    
    /// Проверка срока действия токена.
    private func isTokenExpired(_ token: String) -> Bool {
        do {
            let jwt = try decode(jwt: token)
            if let expiresAt = jwt.expiresAt {
                print("Token expires at \(expiresAt)")
                return expiresAt < Date()
            }
            return true
        } catch {
            print("Ошибка декодирования JWT: \(error)")
            return true
        }
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
        
        if shouldRegister() {
            navigate(to: .signIn)
        } else {
            navigate(to: .main)
        }
    }
    
    func skipSurveyAndRecommendations() {
        if shouldRegister() {
            navigate(to: .signIn)
        } else {
            navigate(to: .main)
        }
    }
    
    func navigate(to route: AppRoute) {
        navigationPath.append(route)
    }
    
    func signOut() {
        clearAllUserData()

        navigateToRegisterView()
    }
    
    func deleteAccountAndResetApp() {
        // 1. Очищаем все пользовательские данные
        clearAllUserData()
        
        // 2. Сбрасываем состояние приложения
        resetAppState()
        
        // 3. Перенаправляем на экран регистрации
        navigateToRegisterView()
    }
    
    private func clearAllUserData() {
        // Очищаем UserDefaults
        UserDefaultsManager.shared.deleteUserEmail()
        UserDefaultsManager.shared.deleteUserName()
        UserDefaultsManager.shared.deleteUserSurname()
        UserDefaultsManager.shared.deleteUserBirthDate()

        
        // Очищаем Keychain
        KeyChainManager.shared.deleteToken()
//        KeyChainManager.shared.deleteUserId()
        KeyChainManager.shared.deletePasswordHash()

    }
    
    private func resetAppState() {
        // Сбрасываем все флаги состояния
        showOnboarding = true
        showWelcomeQuote = true
//        navigationPath = NavigationPath()
        
        // Отменяем все уведомления
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    private func navigateToRegisterView() {
        // Полностью очищаем стек навигации и устанавливаем RegisterView как корневой
        navigationPath.removeLast(navigationPath.count)
        navigate(to: .signIn)
    }
    
    func checkUserExistence(id: String) async -> Bool {
        let endPoint: String = "\(EndPoints.GetUserDataByUserId)/\(id)"
        
        
        let result: Result<EmptyResponse, NetworkError> = await NetworkManager.shared.perfomeRequest(
            endPoint: endPoint,
            method: .GET
        )
        
        switch result {
            case .success(_):
            return true
            case .failure(_):
                return false
        }
    }
}

//
//  PersonalInformationViewModel.swift
//  SoundBathingApp
//
//  Created by Ирина Печик on 06.04.2025.
//

import Foundation

@MainActor
class PersonalInformationViewModel : ObservableObject {
    @Published var name: String = "Name"
    @Published var surname: String = "Surname"
    @Published var email: String = "Email"
    @Published var birthDate: Date = Date.now
    @Published var selectedEmoji: String = "😊"
    @Published var errorMessage: String? = nil

    var isFormValid: Bool {
        !name.isEmpty && !surname.isEmpty && !email.isEmpty
    }
    
    private let emojis = [
        "🐶", "🐱", "🐭", "🐹", "🐰", "🦊", "🐻", "🐼", "🐨", "🐯",
        "🦁", "🐸", "🐵", "🐧", "🐦", "🦉", "🦄",
        "👽", "😎", "🤩", "🥳", "😍",
    ]
    
    private let userDefaultsManager = UserDefaultsManager.shared
    
    private var userId: String? = nil
    
    private var resolvedUserId: String? {
        if let id = userId {
            return id
        }
        
        guard let id = KeyChainManager.shared.getUserId() else {
            errorMessage = "User identification error. Try to re-authorise in the application"
            print(" Ошибка: не удалось получить userId из KeyChain")
            return nil
        }
        
        userId = id
        return id
    }
    
    init() {
        if let username = userDefaultsManager.getUserName() {
            self.name = username
        }

        if let usersurname = userDefaultsManager.getUserSurname() {
            self.surname = usersurname
        }

        if let userEmail = userDefaultsManager.getUserEmail() {
            self.email = userEmail
        }
        
        if let userBirthDate = userDefaultsManager.getUserBirthDate() {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            if let date = formatter.date(from: userBirthDate) {
                self.birthDate = date
            }
        }
        
        selectedEmoji = getEmoji()
    }
    
    func saveUserData() async {
        guard let userId = resolvedUserId else {
            return
        }

        let endPoint = "\(EndPoints.ChangeUserData)/\(userId)"
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        let changeUserDataRequest = ChangeUserDataRequest(
            name: name,
            surname: surname,
            birthDate: formatter.string(from: birthDate)
        )
        
        let body = try? JSONEncoder().encode(changeUserDataRequest)
        
        let result: Result<EmptyResponse, NetworkError> = await NetworkManager.shared.perfomeRequest(
            endPoint: endPoint,
            method: .PATCH,
            body: body
        )

        switch result {
        case .success:
            self.errorMessage = nil
            saveDataToUserDefaults()
        case .failure(let error):
            print(error)
            switch error {
            case .serverError(let message):
                self.errorMessage = message
            default:
                self.errorMessage = error.localizedDescription
            }
        }
    }
    
    // MARK: - Private functions
    private func saveDataToUserDefaults() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        userDefaultsManager.saveUserName(name: name)
        userDefaultsManager.saveUserSurname(surname: surname)
        userDefaultsManager.saveUserBirthDate(birthDate: formatter.string(from: birthDate))
    }
    
    private func getEmoji() -> String {
        if let emoji = userDefaultsManager.getUserEmoji() {
            return emoji
        } else {
            let random = generateRandomEmoji()
            userDefaultsManager.saveUserEmoji(emoji: random)
            return random
        }
    }
    
    private func generateRandomEmoji() -> String {
        emojis.randomElement() ?? "😄"
    }
}

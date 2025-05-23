//
//  UserDefaultsManager.swift
//  SoundBathingApp
//
//  Created by Ирина Печик on 13.02.2025.
//

import Foundation

class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    
    // MARK: User keys
    static let userNameKey: String = "userEmail"
    static let userEmailKey: String = "userName"
    static let userSurnameKey: String = "userSurname"
    static let userEmojiKey: String = "userEmoji"
    static let birthDateKey: String = "userBirthDate"
    static let isRegistered: String = "isRegistered"

    // MARK: Quote
    private let nextUpdateQuoteDateKey = "nextUpdateQuoteDate"
    private let savedQuoteKey = "currentDailyQuote"
    // MARK: - User email.
    func saveUserEmail(email: String) {
        UserDefaults.standard.set(email, forKey: UserDefaultsManager.userEmailKey)
    }
    
    func getUserEmail() -> String? {
        if let email = UserDefaults.standard.string(forKey: UserDefaultsManager.userEmailKey) {
            return email
        }
        return nil
    }
    
    func deleteUserEmail() {
        UserDefaults.standard.removeObject(forKey: UserDefaultsManager.userEmailKey)
    }
    // MARK: - User name.
    func saveUserName(name: String) {
        UserDefaults.standard.set(name, forKey: UserDefaultsManager.userNameKey)
    }
    
    func getUserName() -> String? {
        if let name = UserDefaults.standard.string(forKey: UserDefaultsManager.userNameKey) {
            return name
        }
        return nil
    }
    
    func deleteUserName() {
        UserDefaults.standard.removeObject(forKey: UserDefaultsManager.userNameKey)
    }
    // MARK: - User surname.
    func saveUserSurname(surname: String) {
        UserDefaults.standard.set(surname, forKey: UserDefaultsManager.userSurnameKey)
    }
    
    func getUserSurname() -> String? {
        if let surname = UserDefaults.standard.string(forKey: UserDefaultsManager.userSurnameKey) {
            return surname
        }
        return nil
    }
    
    func deleteUserSurname() {
        UserDefaults.standard.removeObject(forKey: UserDefaultsManager.userSurnameKey)
    }
    // MARK: - User birthDate.
    func saveUserBirthDate(birthDate: String) {
        UserDefaults.standard.set(birthDate, forKey: UserDefaultsManager.birthDateKey)
    }
    
    func getUserBirthDate() -> String? {
        if let birthDate = UserDefaults.standard.string(forKey: UserDefaultsManager.birthDateKey) {
            return birthDate
        }
        return nil
    }
    
    func deleteUserBirthDate() {
        UserDefaults.standard.removeObject(forKey: UserDefaultsManager.birthDateKey)
    }
    // MARK: - User emoji.
    func saveUserEmoji(emoji: String) {
        UserDefaults.standard.set(emoji, forKey: UserDefaultsManager.userEmojiKey)
    }
    
    func getUserEmoji() -> String? {
        if let emoji = UserDefaults.standard.string(forKey: UserDefaultsManager.userEmojiKey) {
            return emoji
        }
        return nil
    }
    // MARK: - Is User registered.
    func setUserRegistered() {
        UserDefaults.standard.set(true, forKey: UserDefaultsManager.isRegistered)
    }
    
    func isUserRegistered() -> Bool {
        return UserDefaults.standard.bool(forKey: UserDefaultsManager.isRegistered)
    }
    
    // MARK: - Quotes.
    
    /// Сохраняет дату следующего дня как дату обновления
    func saveNextQuoteUpdateDate() {
        let calendar = Calendar.current
        if let tomorrow = calendar.date(byAdding: .day, value: 1, to: Date()) {
            UserDefaults.standard.set(tomorrow, forKey: nextUpdateQuoteDateKey)
        }
    }

    /// Получает дату следующего обновления цитаты
    func getNextQuoteUpdateDate() -> Date? {
        return UserDefaults.standard.object(forKey: nextUpdateQuoteDateKey) as? Date
    }
    
    func saveCurrentDailyQuote(_ quote: Quote) {
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(quote) {
            UserDefaults.standard.set(data, forKey: savedQuoteKey)
        }
    }

    func getCurrentDailyQuote() -> Quote? {
        guard let data = UserDefaults.standard.data(forKey: savedQuoteKey) else { return nil }
        let decoder = JSONDecoder()
        return try? decoder.decode(Quote.self, from: data)
    }
}

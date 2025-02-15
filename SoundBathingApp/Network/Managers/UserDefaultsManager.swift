//
//  UserDefaultsManager.swift
//  SoundBathingApp
//
//  Created by Ирина Печик on 13.02.2025.
//

import Foundation

class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    
    static let userNameKey: String = "userEmail"
    static let userEmailKey: String = "userName"
    static let userSurnameKey: String = "userSurname"
    
    static let birthDateKey: String = "userBirthDate"
    
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

}

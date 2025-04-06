//
//  KeyChainManager.swift
//  SoundBathingApp
//
//  Created by Ирина Печик on 07.02.2025.
//

import Foundation
import SwiftKeychainWrapper

// TODO: получение роли пользователя, сохранение имени
class KeyChainManager {
    static let shared = KeyChainManager()
    private let jwtTokenKey: String = "jwt_token"
    private let userIdKey: String = "user_id"
    private let userPasswordHash: String = "user_password_hash"

    // MARK: - Token
    func saveToken(_ token: String) {
        KeychainWrapper.standard.set(token, forKey: jwtTokenKey)
    }
    
    func getToken() -> String? {
        return KeychainWrapper.standard.string(forKey: jwtTokenKey)
    }
    
    func deleteToken() {
        KeychainWrapper.standard.removeObject(forKey: jwtTokenKey)
    }
    
    // MARK: - UserId
    func saveUserId(_ userId: String) {
        KeychainWrapper.standard.set(userId, forKey: userIdKey)
    }
    
    func getUserId() -> String? {
        return KeychainWrapper.standard.string(forKey: userIdKey)
    }
    
    func deleteUserId() {
        KeychainWrapper.standard.removeObject(forKey: userIdKey)
    }
    
    // MARK: - PasswordHash
    func saveUserPasswordHash(_ password: String) {
        KeychainWrapper.standard.set(password, forKey: userPasswordHash)
    }
    
    func getUserPasswordHash() -> String? {
        return KeychainWrapper.standard.string(forKey: userPasswordHash)
    }

}

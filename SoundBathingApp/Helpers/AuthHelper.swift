//
//  AuthHelpers.swift
//  SoundBathingApp
//
//  Created by Ирина Печик on 26.04.2025.
//

import Foundation
import CryptoKit

struct AuthHelper {
    static func hashPassword(_ password: String) -> String {
        let data = Data(password.utf8)
        let hash = SHA256.hash(data: data)
        return hash.map { String(format: "%02hhx", $0) }.joined()
    }
}

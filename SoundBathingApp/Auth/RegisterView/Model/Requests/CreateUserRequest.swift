//
//  CreateUserRequest.swift
//  SoundBathingApp
//
//  Created by Ирина Печик on 14.02.2025.
//

import Foundation

struct CreateUserRequest: Codable {
    let userId: String
    let name: String
    let surname: String
    let birthDate: String
}

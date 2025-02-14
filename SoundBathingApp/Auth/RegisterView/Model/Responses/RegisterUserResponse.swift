//
//  RegisterUserResponse.swift
//  SoundBathingApp
//
//  Created by Ирина Печик on 06.02.2025.
//

import Foundation

struct RegisterUserResponse: Codable, Hashable {
    let token: String
    let userId: String
}

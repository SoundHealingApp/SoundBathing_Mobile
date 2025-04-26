//
//  SignInModel.swift
//  SoundBathingApp
//
//  Created by Ирина Печик on 15.02.2025.
//

import Foundation

struct SignInRequest : Codable {
    let email: String
    let hashedPassword: String
}

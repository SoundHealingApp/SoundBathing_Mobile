//
//  GetUserDataResponse.swift
//  SoundBathingApp
//
//  Created by Ирина Печик on 27.04.2025.
//

import Foundation

struct GetUserDataResponse: Codable, Hashable {
    let id: String
    let name: String
    let surname: String
    let birthDate: String
}

//
//  ChangeUserDataRequest.swift
//  SoundBathingApp
//
//  Created by Ирина Печик on 06.04.2025.
//

import Foundation

struct ChangeUserDataRequest : Codable {
    let name: String?
    let surname: String?
    let birthDate: String?
}

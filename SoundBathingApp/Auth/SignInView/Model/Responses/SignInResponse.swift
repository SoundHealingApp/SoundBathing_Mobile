//
//  SignInResponse.swift
//  SoundBathingApp
//
//  Created by Ирина Печик on 15.02.2025.
//

import Foundation

struct SignInResponse: Codable, Hashable {
    let token: String
    let userId: String // TODO: выпилить, если не понадобится
}

//
//  ServerErrorResponse.swift
//  SoundBathingApp
//
//  Created by Ирина Печик on 08.02.2025.
//

import Foundation

struct ServerErrorResponse: Codable {
    let status: Int
    let detail: String
}

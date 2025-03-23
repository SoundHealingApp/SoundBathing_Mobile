//
//  Feedbacks.swift
//  SoundBathingApp
//
//  Created by Ирина Печик on 24.02.2025.
//

import Foundation

struct Feedbacks: Codable {
    var userId: String
    var meditationId: String
    var comment: String?
    var estimate: Int
}

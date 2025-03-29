//
//  Feedbacks.swift
//  SoundBathingApp
//
//  Created by Ирина Печик on 24.02.2025.
//

import Foundation

struct Feedback: Codable, Identifiable {
    var id: String
    var meditationId: String
    let userName: String
    var comment: String?
    var estimate: Int
}

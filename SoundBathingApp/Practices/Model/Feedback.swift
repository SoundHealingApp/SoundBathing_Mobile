//
//  Feedbacks.swift
//  SoundBathingApp
//
//  Created by Ирина Печик on 24.02.2025.
//

import Foundation

struct Feedback: Codable, Identifiable, Equatable {
    var id: String
    var meditationId: String
    let userName: String
    var comment: String?
    var estimate: Int
    
    // Реализация протокола Equatable
    static func == (lhs: Feedback, rhs: Feedback) -> Bool {
        return lhs.id == rhs.id &&
               lhs.meditationId == rhs.meditationId
    }
}

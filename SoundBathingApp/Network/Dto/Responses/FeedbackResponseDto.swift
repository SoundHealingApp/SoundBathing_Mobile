//
//  FeedbackDto.swift
//  SoundBathingApp
//
//  Created by Ирина Печик on 29.03.2025.
//

import Foundation

struct FeedbackResponseDto: Codable {
    var userId: String
    var meditationId: String
    var comment: String?
    var userName: String
    var estimate: Int
}

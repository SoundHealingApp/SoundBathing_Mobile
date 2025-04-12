//
//  FeedbackRequestDto.swift
//  SoundBathingApp
//
//  Created by Ирина Печик on 31.03.2025.
//

import Foundation

struct AddFeedbackRequestDto: Codable {
    var userId: String
    var comment: String?
    var estimate: Int
}

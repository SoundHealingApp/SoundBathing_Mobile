//
//  ChangeFeedbackRequestDto.swift
//  SoundBathingApp
//
//  Created by Ирина Печик on 01.04.2025.
//

import Foundation

struct ChangeFeedbackRequestDto: Codable {
    var comment: String?
    var estimate: Int
}

//
//  CreatePracticeRequest.swift
//  SoundBathingApp
//
//  Created by Ирина Печик on 23.02.2025.
//

import Foundation

struct CreatePracticeRequest: Codable {
    let title: String
    let description: String
    var meditationType: MeditationCategory
    var therapeuticPurpose: String
    var frequency: String
    var data: Data
    var image: Data
}

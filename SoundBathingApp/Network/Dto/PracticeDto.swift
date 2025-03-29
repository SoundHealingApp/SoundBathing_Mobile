//
//  Practice.swift
//  SoundBathingApp
//
//  Created by Ирина Печик on 24.02.2025.
//

import Foundation

struct PracticeDto: Identifiable, Codable {
    var id: String
    var title: String
    var description: String
    var meditationType: MeditationCategory
    var therapeuticPurpose: String
    var rating: Double?
    var imageLink: String
    var audioLink: String
    var frequency: Double?
}

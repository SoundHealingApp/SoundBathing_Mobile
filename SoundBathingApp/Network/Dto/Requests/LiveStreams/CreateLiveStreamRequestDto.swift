//
//  CreateLiveStreamRequestDto.swift
//  SoundBathingApp
//
//  Created by Ирина Печик on 13.04.2025.
//

import Foundation

struct CreateLiveStreamRequestDto : Codable {
    var title: String
    var description: String
    var therapeuticPurpose: String
    var startDateTime: String
    var youTubeUrl: String
}

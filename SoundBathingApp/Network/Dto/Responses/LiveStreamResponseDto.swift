//
//  UpcomingLiveStreamsResponseDto.swift
//  SoundBathingApp
//
//  Created by Ирина Печик on 13.04.2025.
//

import Foundation

struct LiveStreamResponseDto : Codable {
    var id: String
    var title: String
    var description: String
    var therapeuticPurpose: String
    var formattedStartDateTime: String
    var youTubeUrl: String
}

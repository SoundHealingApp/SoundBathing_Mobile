//
//  LiveStream.swift
//  SoundBathingApp
//
//  Created by Ирина Печик on 12.04.2025.
//

import Foundation

struct LiveStream : Identifiable, Codable, Equatable {
    let id: String
    
    var title: String
    var description: String
    var therapeuticPurpose: String
    var startDateTime: Date
    var youTubeUrl: String
    
    init(
        id: String,
        title: String,
        description: String,
        therapeuticPurpose: String,
        startDateTime: Date,
        youTubeUrl: String
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.therapeuticPurpose = therapeuticPurpose
        self.startDateTime = startDateTime
        self.youTubeUrl = youTubeUrl
    }
}

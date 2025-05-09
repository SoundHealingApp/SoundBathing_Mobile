//
//  LiveStream.swift
//  SoundBathingApp
//
//  Created by Ирина Печик on 12.04.2025.
//

import Foundation

struct LiveStream : Identifiable, Codable, Equatable, Hashable {
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
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id) // Используем только id для хэширования
    }

    static func == (lhs: LiveStream, rhs: LiveStream) -> Bool {
        return lhs.id == rhs.id // Сравнение только по id
    }
}

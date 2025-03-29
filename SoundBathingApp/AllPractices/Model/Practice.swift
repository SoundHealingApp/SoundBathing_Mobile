//
//  Practice.swift
//  SoundBathingApp
//
//  Created by Ирина Печик on 25.02.2025.
//

import Foundation
import UIKit

struct Practice: Identifiable, Hashable {
    var id: String
    var title: String
    var description: String
    var meditationType: MeditationCategory
    var therapeuticPurpose: String
    var rating: Double?
    var image: UIImage
    var frequency: Double?
    var feedbacks: [Feedback]
    var isFavorite: Bool
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id) // Используем только id для хэширования
    }

    static func == (lhs: Practice, rhs: Practice) -> Bool {
        return lhs.id == rhs.id // Сравнение только по id
    }
}

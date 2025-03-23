//
//  PracticeSongModel.swift
//  SoundBathingApp
//
//  Created by Ирина Печик on 18.02.2025.
//

import Foundation
import UIKit

//struct PracticeSongModel: Identifiable {
//    var id = UUID()
//    var title: String
//    var description: String
//    var meditationType: MeditationCategory
//    var therapeuticPurpose: String
//    var frequency: String?
//    var data: Data
//    var image: UIImage?
//    var duration: TimeInterval
//}

enum MeditationCategory: String, CaseIterable, Identifiable, Codable {
    case daily = "Guided Daily Moments"
    case restorative = "Restorative Sound Bath"
    
    var id: String {
        self.rawValue
    }
    
    var numericValue: Int {
        switch self {
        case .daily:
            return 0
        case .restorative:
            return 1
        }
    }
    
    // Кодирование в numericValue
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(numericValue)
    }
    
    // Декодирование из numericValue
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let numericValue = try container.decode(Int.self)
        
        switch numericValue {
        case 0:
            self = .daily
        case 1:
            self = .restorative
        default:
            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "Invalid numeric value for MeditationCategory"
            )
        }
    }
}

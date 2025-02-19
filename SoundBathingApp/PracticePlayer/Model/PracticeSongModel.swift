//
//  PracticeSongModel.swift
//  SoundBathingApp
//
//  Created by Ирина Печик on 18.02.2025.
//

import Foundation
import UIKit

struct PracticeSongModel: Identifiable {
    var id = UUID()
    var title: String?
    var description: String?
    var meditationType: MeditationCategory?
    var therapeuticPurpose: String?
    var frequency: String?
    var data: Data
    var image: UIImage?
    var duration: TimeInterval?
}

enum MeditationCategory: String, CaseIterable, Identifiable {
    case daily = "Guided daily moments"
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
}

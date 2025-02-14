//
//  BirthDateViewModel.swift
//  SoundBathingApp
//
//  Created by Ирина Печик on 14.02.2025.
//

import Foundation

public class BirthDateViewModel: ObservableObject {
    
    func saveBirthBateToUserDefaults(birthDate: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let formatedDate = dateFormatter.string(from: birthDate)
        UserDefaultsManager.shared.saveUserBirthDate(birthDate: formatedDate)
    }
}

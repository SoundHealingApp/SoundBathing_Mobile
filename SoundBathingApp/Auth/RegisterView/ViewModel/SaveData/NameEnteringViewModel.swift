//
//  NameEnteringViewModel.swift
//  SoundBathingApp
//
//  Created by Ирина Печик on 13.02.2025.
//

import SwiftUI

class NameEnteringViewModel: ObservableObject{
    func saveNameDataToUserDefaults(name: String, surname: String) {
        UserDefaultsManager.shared.saveUserName(name: name);
        UserDefaultsManager.shared.saveUserSurname(surname: surname)
    }
}

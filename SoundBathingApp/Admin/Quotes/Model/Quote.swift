//
//  Quote.swift
//  SoundBathingApp
//
//  Created by Ирина Печик on 08.04.2025.
//

import Foundation

struct Quote: Identifiable, Codable, Equatable {
    let id: String
    var author: String
    var text: String
    
    init(id: String, author: String, text: String) {
        self.id = id
        self.author = author
        self.text = text
    }
}

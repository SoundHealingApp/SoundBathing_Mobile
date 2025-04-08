//
//  QuotesViewModel.swift
//  SoundBathingApp
//
//  Created by Ирина Печик on 08.04.2025.
//

import Foundation
// TODO: change to real server
class QuotesViewModel: ObservableObject {
    @Published var quotes: [Quote] = []
    @Published var showingAddQuote = false
    @Published var editingQuote: Quote?
    
    private let saveKey = "saved_quotes"
    
    init() {
        loadQuotes()
    }
    
    func addQuote(_ quote: Quote) {
        quotes.append(quote)
        saveQuotes()
    }
    
    func updateQuote(_ updatedQuote: Quote) {
        if let index = quotes.firstIndex(where: { $0.id == updatedQuote.id }) {
            quotes[index] = updatedQuote
            saveQuotes()
        }
    }
    
    func deleteQuote(at offsets: IndexSet) {
        quotes.remove(atOffsets: offsets)
        saveQuotes()
    }
    
    func deleteQuote(_ quote: Quote) {
        quotes.removeAll { $0.id == quote.id }
        saveQuotes()
    }
    
    private func loadQuotes() {
        if let data = UserDefaults.standard.data(forKey: saveKey) {
            if let decoded = try? JSONDecoder().decode([Quote].self, from: data) {
                quotes = decoded
                return
            }
        }
        // Default quotes if none saved
        quotes = [
            Quote(author: "Oscar Wilde", text: "You can never be overdressed or overeducated."),
            Quote(author: "Japanese Proverb", text: "Fall seven times and stand up eight")
        ]
    }
    
    private func saveQuotes() {
        if let encoded = try? JSONEncoder().encode(quotes) {
            UserDefaults.standard.set(encoded, forKey: saveKey)
        }
    }
}

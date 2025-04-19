//
//  QuotesViewModel.swift
//  SoundBathingApp
//
//  Created by Ирина Печик on 08.04.2025.
//

import Foundation
import SwiftUI

@MainActor
class QuotesViewModel: ObservableObject {
    @Published var quotes: [Quote] = []
    @Published var showingAddQuote = false
    @Published var editingQuote: Quote?
    @Published var errorMessage: String? = nil

    
    /// Добавление и сохранение практики. + сделать кэширование
    func addQuote(_ createQuoteRequest: CreateQuoteRequestDto) async {
        let endPoint = EndPoints.CreateQuote
        
        let body = try? JSONEncoder().encode(createQuoteRequest)
        
        let result: Result<String, NetworkError> = await NetworkManager.shared.perfomeRequest(
            endPoint: endPoint,
            method: .POST,
            body: body
        )
        
        switch result {
        case .success(let quoteId):
            quotes.append(
                Quote(
                    id: quoteId,
                    author: createQuoteRequest.author,
                    text: createQuoteRequest.text
                )
            )
            self.errorMessage = nil
            print("Quote saved")
        case .failure(let error):
            print(error)
            switch error {
            case .serverError(let message):
                self.errorMessage = message
            default:
                self.errorMessage = error.localizedDescription
            }
        }
    }
    
    /// Получение всех цитат с сервера.
    func getAllQuotes() async {
        let endPoint = EndPoints.GetQuotes
        
        let result: Result<[QuotesResponseDto], NetworkError> = await NetworkManager.shared.perfomeRequest(
            endPoint: endPoint,
            method: .GET
        )
        
        switch result {
            case .success(let quotesDtos):
                createQuotesModels(quotesDtos: quotesDtos)
                self.errorMessage = nil
            case .failure(let error):
                switch error {
                case .serverError(let message):
                    self.errorMessage = message
                default:
                    self.errorMessage = error.localizedDescription
                }
        }
    }
    
    /// Получение рандомной цитаты.
    // TODO: сделать, чтобы не повторялись
    func getDailyRandomQuote() async -> Quote? {
        let currentQuote = UserDefaultsManager.shared.getCurrentDailyQuote()
        
        if !shouldUpdateQuote() && currentQuote != nil {
            return currentQuote
        }
        
        let endPoint = EndPoints.GetRandomQuote
        
        let result: Result<QuotesResponseDto, NetworkError> = await NetworkManager.shared.perfomeRequest(
            endPoint: endPoint,
            method: .GET
        )

        switch result {
            case .success(let quoteDto):
                self.errorMessage = nil
                return saveQuote(quoteDto: quoteDto)
            case .failure(let error):
                switch error {
                case .serverError(let message):
                    self.errorMessage = message
                default:
                    self.errorMessage = error.localizedDescription
                }
                return nil
        }
    }
    
    /// Обновить цитату.
    func updateQuote(updatedQuote: Quote) async {
        let endPoint = "\(EndPoints.UpdateQuote)/\(updatedQuote.id)"
        
        if let index = quotes.firstIndex(where: { $0.id == updatedQuote.id }) {
            quotes[index] = updatedQuote
        }

        let body = try? JSONEncoder().encode(updatedQuote)
        
        let result: Result<EmptyResponse, NetworkError> = await NetworkManager.shared.perfomeRequest(
            endPoint: endPoint,
            method: .PUT,
            body: body
        )
        
        switch result {
        case .success:
            print("okk!")
            self.errorMessage = nil
        case .failure(let error):
            print(error)
            switch error {
            case .serverError(let message):
                self.errorMessage = message
            default:
                self.errorMessage = error.localizedDescription
            }
        }
    }
    
    /// Удалить цитату.
    func deleteQuote(id: String) async {
        await MainActor.run {
            withAnimation(.interactiveSpring(response: 0.3, dampingFraction: 0.7)) {
                quotes.removeAll { $0.id == id }
            }
        }
        
        let endPoint = "\(EndPoints.DeleteQuote)/\(id)"

        let result: Result<EmptyResponse, NetworkError> = await NetworkManager.shared.perfomeRequest(
            endPoint: endPoint,
            method: .DELETE
        )
        
        switch result {
        case .success:
            print("okd!")
            self.errorMessage = nil
        case .failure(let error):
            print(error)
            switch error {
            case .serverError(let message):
                self.errorMessage = message
            default:
                self.errorMessage = error.localizedDescription
            }
        }
    }
    // MARK: - Private methods
    private func createQuotesModels(quotesDtos: [QuotesResponseDto]) {
        for quoteDto in quotesDtos {
            guard !quotes.contains(where: { $0.id == quoteDto.id }) else {
                continue
            }
            
            let quote = Quote(
                id: quoteDto.id,
                author: quoteDto.author,
                text: quoteDto.text
            )
            
            quotes.append(quote)
        }
    }
    
    /// Проверяет, можно ли уже обновлять цитату
    private func shouldUpdateQuote() -> Bool {
        guard let nextDate = UserDefaultsManager.shared.getNextQuoteUpdateDate() else {
            return true
        }
        return Date() >= nextDate
    }
    
    /// Сохранение цитаты и временик следующего обновления в UserDefaults
    private func saveQuote(quoteDto: QuotesResponseDto) -> Quote {
        var quote = Quote(id: quoteDto.id, author: quoteDto.author, text: quoteDto.text)
        
        UserDefaultsManager.shared.saveCurrentDailyQuote(quote)
        UserDefaultsManager.shared.saveNextQuoteUpdateDate()
        
        return quote
    }
}

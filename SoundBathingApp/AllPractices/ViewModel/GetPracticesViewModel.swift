//
//  GetPracticesViewModel.swift
//  SoundBathingApp
//
//  Created by Ирина Печик on 24.02.2025.
//

import Foundation
import UIKit

@MainActor
class GetPracticesViewModel: ObservableObject {
    @Published var errorMessage: String? = nil
    @Published var isLoading: Bool = false
    
    @Published var practices: [Practice] = []
    @Published var likedPractices: [Practice] = []

    private var likedPracticeIds: Set<String> = []
    private var userId: String? = nil

    /// Скачивание всех практик. Подумать над тем, чтобы скачивать не все
    func getAllPractices() async {
        await getLikedPracticeIds()
        await getPracticesByType(type: MeditationCategory.daily)
        await getPracticesByType(type: MeditationCategory.restorative)
    }
    
    /// Получение понравивашихся практик
    func getLikedPractices() {
        likedPractices = practices.filter { likedPracticeIds.contains($0.id) }
    }
    
    /// Переключение лайка
    func toggleLike(practiceId: String) async {
        if let index = practices.firstIndex(where: { $0.id == practiceId }) {
            if !practices[index].isFavorite {
                await likePractice(practiceId: practiceId)
            } else {
                await unlikePractice(practiceId: practiceId)
            }
            
            practices[index].isFavorite.toggle()
        }
    }
    
    // MARK: - Private methods
    private func likePractice(practiceId: String) async {
        if !likedPracticeIds.contains(practiceId) {
            likedPracticeIds.insert(practiceId)
        }
    
        if userId == nil {
            guard let id = KeyChainManager.shared.getUserId() else {
                print("Ошибка: не удалось получить userId из KeyChain")
                errorMessage = "User identification error. Try to re-authorise in the application"
                return
            }
            
            userId = id
        }

        
        let endPoint = "/users/\(userId!)/\(EndPoints.GetLikedPractices)/\(practiceId)"
        
        let result: Result<EmptyResponse, NetworkError> = await NetworkManager.shared.perfomeRequest(
            endPoint: endPoint,
            method: .POST
        )
        
        switch result {
            case .success:
                self.errorMessage = nil
                print("Лайк успешно добавлен")
            case .failure(let error):
                print("Ошибка добавления лайка")
                switch error {
                case .serverError(let message):
                    self.errorMessage = message
                default:
                    self.errorMessage = error.localizedDescription
                }
            }
        
    }
    
    private func unlikePractice(practiceId: String) async {
        likedPracticeIds.remove(practiceId)
        likedPractices.removeAll { $0.id == practiceId }
        
        if userId == nil {
            guard let id = KeyChainManager.shared.getUserId() else {
                print("Ошибка: не удалось получить userId из KeyChain")
                errorMessage = "User identification error. Try to re-authorise in the application"
                return
            }
            
            userId = id
        }
        
        let endPoint = "/users/\(userId!)/\(EndPoints.GetLikedPractices)/\(practiceId)"
        
        let result: Result<EmptyResponse, NetworkError> = await NetworkManager.shared.perfomeRequest(
            endPoint: endPoint,
            method: .DELETE
        )
        
        switch result {
            case .success:
                self.errorMessage = nil
                print("Лайк успешно удален")
            case .failure(let error):
                print("Ошибка удаления лайка")
                switch error {
                case .serverError(let message):
                    self.errorMessage = message
                default:
                    self.errorMessage = error.localizedDescription
                }
            }
    }
    
    /// Скачивание практики по типу
    private func getPracticesByType(type: MeditationCategory) async {
        let endPoint = "\(EndPoints.GetPracticesByType)/\(type.numericValue)"
        
        let result: Result<[PracticeDto], NetworkError> = await NetworkManager.shared.perfomeRequest(
            endPoint: endPoint,
            method: .GET
        )
        
        switch result {
            case .success(let practices):
                await createPracticesModels(practicesDtos: practices)
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
    
    /// Получение понравившися практик.
    private func getLikedPracticeIds() async {
        guard let userId = KeyChainManager.shared.getUserId() else {
            print("Ошибка: не удалось получить userId из KeyChain")
            errorMessage = "User identification error. Try to re-authorise in the application"
            return
        }
        
        let endPoint = "/users/\(userId)/\(EndPoints.GetLikedPractices)"
        
        let result: Result<[PracticeDto], NetworkError> = await NetworkManager.shared.perfomeRequest(
            endPoint: endPoint,
            method: .GET
        )
        
        switch result {
            case .success(let practices):
                for practice in practices {
                    likedPracticeIds.insert(practice.id)
                }
            
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
    
    /// Преобразование ответа от сервера в модели практик
    private func createPracticesModels(practicesDtos: [PracticeDto]) async {
        for practiceDto in practicesDtos {
            guard !practices.contains(where: { $0.id == practiceDto.id }) else {
                continue
            }
            
            if let practiceImage = await downloadPracticeImage(practiceId: practiceDto.id) {
                let isPracticeLiked = likedPracticeIds.contains(practiceDto.id)

                let practice = Practice(
                    id: practiceDto.id,
                    title: practiceDto.title,
                    description: practiceDto.description,
                    meditationType: practiceDto.meditationType,
                    therapeuticPurpose: practiceDto.therapeuticPurpose,
                    image: practiceImage,
                    frequency: practiceDto.frequency,
                    feedbacks: practiceDto.feedbacks,
                    isFavorite: isPracticeLiked ? true : false
                )
                
                practices.append(practice)
            }
        }
    }
    

    /// Скачивание изображения практки
    private func downloadPracticeImage(practiceId: String) async -> UIImage? {
        let endPoint = "\(EndPoints.DownloadPracticeImage)/\(practiceId)/image"
        
        let result = await NetworkManager.shared.downloadImage(from: endPoint)
        
        switch result {
        case .success(let image):
            return image
        case .failure(let error):
            print("Ошибка загрузки изображения c id \(practiceId): \(error)")
            return nil
        }
    }
}

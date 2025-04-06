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
    
    private var likedPracticeIdsSet: Set<String> = []
    private var userId: String? = nil
    private var resolvedUserId: String? {
        if let id = userId {
            return id
        }
        
        guard let id = KeyChainManager.shared.getUserId() else {
            errorMessage = "User identification error. Try to re-authorise in the application"
            print(" Ошибка: не удалось получить userId из KeyChain")
            return nil
        }
        
        userId = id
        return id
    }

    /// Скачивание всех практик. Подумать над тем, чтобы скачивать не все
    func getAllPractices() async {
        await withTaskGroup(of: Void.self) { group in
            group.addTask { await self.getLikedPracticeIds() }

            MeditationCategory.allCases.forEach { category in
                group.addTask { await self.getPracticesByType(type: category) }
            }
        }
    }
    
    /// Переключение лайка
    func toggleLike(practiceId: String) async {
        if let index = practices.firstIndex(where: { $0.id == practiceId }) {
            if !practices[index].isFavorite {
                await likePractice(practiceId: practiceId)
            } else {
                await unlikePractice(practiceId: practiceId)
            }
            print(practices[index].isFavorite)
            practices[index].isFavorite.toggle()
        }
    }
    
    // MARK: - Private methods
    private func likePractice(practiceId: String) async {
        guard let userId = resolvedUserId else { return }
        
        let endPoint = "/users/\(userId)/\(EndPoints.GetLikedPractices)/\(practiceId)"
        
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
        guard let userId = resolvedUserId else { return }
        
        let endPoint = "/users/\(userId)/\(EndPoints.GetLikedPractices)/\(practiceId)"
        
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
    
    /// Получение понравившися практик из бд.
    private func getLikedPracticeIds() async {
        guard let userId = resolvedUserId else { return }
        
        let endPoint = "/users/\(userId)/\(EndPoints.GetLikedPractices)"
        
        let result: Result<[PracticeDto], NetworkError> = await NetworkManager.shared.perfomeRequest(
            endPoint: endPoint,
            method: .GET
        )
        
        switch result {
            case .success(let practices):
                likedPracticeIdsSet = Set(practices.map { $0.id })
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
        for dto in practicesDtos where !practices.contains(where: { $0.id == dto.id }) {
            async let image = downloadPracticeImage(practiceId: dto.id)
            async let audio = downloadPracticeAudio(practiceId: dto.id)
            
            if let image = await image, let audio = await audio {
                    let isLiked = likedPracticeIdsSet.contains(dto.id)

                    let practice = Practice(
                        id: dto.id,
                        title: dto.title,
                        description: dto.description,
                        meditationType: dto.meditationType,
                        therapeuticPurpose: dto.therapeuticPurpose,
                        image: image,
                        audio: audio,
                        frequency: dto.frequency,
                        feedbacks: [], /// не подргружаем на данном этапе отзывы
                        isFavorite: isLiked
                    )
                    
                    practices.append(practice)
                }
            }
        }
    }
    

    /// Скачивание изображения практки
    private func downloadPracticeImage(practiceId: String) async -> UIImage? {
        if let cached = PracticeAssetCache.shared.image(for: practiceId) {
            return cached
        }
        
        let endPoint = "\(EndPoints.DownloadPracticeImage)/\(practiceId)/image"
        
        let result = await NetworkManager.shared.downloadImage(from: endPoint)
        
        switch result {
        case .success(let image):
            PracticeAssetCache.shared.set(image: image, for: practiceId)
            return image
        case .failure(let error):
            print("Ошибка загрузки изображения c id \(practiceId): \(error)")
            return nil
        }
    }
    
    /// Скачивание аудио практки
    private func downloadPracticeAudio(practiceId: String) async -> Data? {
        if let cached = PracticeAssetCache.shared.audio(for: practiceId) {
            return cached
        }
        
        let endPoint = "\(EndPoints.DownloadPracticeAudio)/\(practiceId)/audio"
        
        let result = await NetworkManager.shared.downloadAudio(from: endPoint)
        
        switch result {
        case .success(let audio):
            PracticeAssetCache.shared.set(audio: audio, for: practiceId)
            return audio
        case .failure(let error):
            print("Ошибка загрузки аудио c id \(practiceId): \(error)")
            return nil
        }
    }


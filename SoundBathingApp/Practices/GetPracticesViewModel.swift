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
    
    @Published var recommendedPracticesIdsSet: Set<String> = []
    private var likedPracticeIdsSet: Set<String> = []

    private var audioLoadingTasks: [String: Task<Data?, Never>] = [:]
    @Published var isLoadingAudio: Bool = false

    /// Рекомендованные практики (только для чтения извне)
    var recommendedPractices: [Practice] {
        practices.filter { recommendedPracticesIdsSet.contains($0.id) }
    }
    
    /// Id пользователя.
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
    
    /// Добавление списка практик в ремендованные.
    func addPracticesToRecommended() async {
        await recommendPractice(practiceIds: Array(recommendedPracticesIdsSet))
    }
    
    /// Добавление аудио практики.
    func updatePracticeAudio(practiceId: String, audio: Data) {
        if let index = practices.firstIndex(where: {$0.id == practiceId}) {
            practices[index].audio = audio
        }
    }
    
    // Основной метод для пакетной загрузки аудио
    func loadRecommendedPracticesAudio() async {
        guard !recommendedPracticesIdsSet.isEmpty else { return }
        
//        isLoadingAudio = true
//        defer { isLoadingAudio = false }
        
        await withTaskGroup(of: Void.self) { group in
            for practiceId in recommendedPracticesIdsSet {
                group.addTask {
                    await self.loadAudioForPractice(id: practiceId)
                }
            }
        }
    }
    
    // Получаем аудио из массива practices
    func loadAudioForPractice(id: String) async -> Data? {
        if let audio = practices.first(where: { $0.id == id })?.audio {
            return audio
        }
        
        // 2. Если загрузка уже идет - возвращаем задачу
        if let existingTask = audioLoadingTasks[id] {
            return await existingTask.value
        }
        
        // 3. Начинаем новую загрузку
        let task = Task<Data?, Never> {
            defer { audioLoadingTasks[id] = nil }
            return await downloadAndStoreAudio(practiceId: id)
        }
        
        audioLoadingTasks[id] = task
        return await task.value
    }
    
    // Загрузка и сохранение аудио для одной практики
    private func downloadAndStoreAudio(practiceId: String) async -> Data? {
        isLoadingAudio = true
        defer { isLoadingAudio = false } 
        
        guard let index = practices.firstIndex(where: { $0.id == practiceId }) else {
            return nil
        }
        
        let audioData = await downloadPracticeAudio(practiceId: practiceId)
        
        practices[index].audio = audioData
        
        return audioData
    }

    // MARK: - Private methods
    
    // MARK: Like/unlike practice
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

    // MARK: Recommend practices
    /// Добавление практик в рекомендованные.
    private func recommendPractice(practiceIds: [String]) async {
        guard let userId = resolvedUserId else { return }
        
        let endPoint = "\(EndPoints.AddPracticesToRecommended)/\(userId)/recommended-meditations"
        
        let queryParameters = [
            "meditationId": practiceIds
        ]
        
        let result: Result<EmptyResponse, NetworkError> = await NetworkManager.shared.perfomeRequest(
            endPoint: endPoint,
            method: .POST,
            queryParameters: queryParameters
        )
        
        switch result {
            case .success:
                self.errorMessage = nil
                print("Рекомендации практик успешно добавлены")
            case .failure(let error):
                print("Ошибка добавления рекомендаций практик")
                switch error {
                case .serverError(let message):
                    self.errorMessage = message
                default:
                    self.errorMessage = error.localizedDescription
                }
            }
    }
    
    /// Получение рекомендованных практик.
    private func getRecommendedPractices(userId: String) async {
        let endPoint = "\(EndPoints.GetRecommendedPractices)/\(userId)/recommended-meditations"

        let result: Result<EmptyResponse, NetworkError> = await NetworkManager.shared.perfomeRequest(
            endPoint: endPoint,
            method: .GET
        )
        
        switch result {
            case .success:
                self.errorMessage = nil
                print("Рекомендованные практики успешно получены")
            case .failure(let error):
                print("Ошибка получения рекомендованных практик")
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
            
            if let image = await image {
                    let isLiked = likedPracticeIdsSet.contains(dto.id)

                    let practice = Practice(
                        id: dto.id,
                        title: dto.title,
                        description: dto.description,
                        meditationType: dto.meditationType,
                        therapeuticPurpose: dto.therapeuticPurpose,
                        image: image,
                        audio: nil, /// Не подгружаем на этом этапе аудио.
                        frequency: dto.frequency,
                        feedbacks: [], /// не подргружаем на данном этапе отзывы
                        isFavorite: isLiked
                    )
                    
                    practices.append(practice)
                }
            }
        }
    
    /// Скачивание аудио практки
    public func downloadPracticeAudio(practiceId: String) async -> Data? {
        /// Cмотрим, загружали ли мы уже аудио у данной практики.
        if let practice = getPracticeFromArray(by: practiceId) {
            if let audio = practice.audio {
                return audio
            }
        }
        
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
    
    // MARK: - Private methods
    
    /// Скачивание изображения практки
    private func downloadPracticeImage(practiceId: String) async -> UIImage? {
        /// Cмотрим, загружали ли мы уже изображение у данной практики.
        if let practice = getPracticeFromArray(by: practiceId) {
            return practice.image
        }
        
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
    
    private func getPracticeFromArray(by id: String) -> Practice? {
        return practices.first { $0.id == id }
    }
}

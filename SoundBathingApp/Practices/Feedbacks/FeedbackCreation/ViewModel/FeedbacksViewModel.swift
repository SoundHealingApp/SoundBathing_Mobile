//
//  GetPracticeFeedbacksViewModel.swift
//  SoundBathingApp
//
//  Created by Ирина Печик on 29.03.2025.
//

import Foundation
import SwiftUI

@MainActor
public class FeedbacksViewModel : ObservableObject {
    // MARK: - Public properties
    @Published var feedbacks: [Feedback] = []
    @Published var errorMessage: String? = nil
    
    var averageRating: Double {
        guard !feedbacks.isEmpty else {
            return 0
        }
        
        let total = feedbacks.reduce(0) {
            $0 + Double($1.estimate)
        }
        
        return total / Double(feedbacks.count)
    }
    
    // MARK: - Public methods
    
    // MARK: GET methods
    func getPracticeFeedBacks(practiceId: String) async {
        let endPoint = "\(EndPoints.GetPracticeFeedbacks)/\(practiceId)/feedbacks"
        
        let result: Result<[FeedbackResponseDto], NetworkError> = await NetworkManager.shared.perfomeRequest(
            endPoint: endPoint,
            method: .GET
        )
        
        switch result {
            case .success(let feedbacks):
            await createFeedbacksModels(feedbacksDtos: feedbacks)
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
    
    // MARK: POST methods
    func addFeedback(practiceId: String, feedback: AddFeedbackRequestDto) async {
        let newFeedback = Feedback(
            id: feedback.userId,
            meditationId: practiceId,
            userName: UserDefaultsManager.shared.getUserName()!,
            comment: feedback.comment,
            estimate: feedback.estimate
        )
        feedbacks.append(newFeedback)
        
        let endPoint = "\(EndPoints.AddPracticeFeedback)/\(practiceId)/feedback"
        
        let body = try? JSONEncoder().encode(feedback)
        
        let result: Result<EmptyResponse, NetworkError> = await NetworkManager.shared.perfomeRequest(
            endPoint: endPoint,
            method: .POST,
            body: body
        )
        
        switch result {
        case .success:
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
    
    // MARK: PUT methods
    func changeFeedback(practiceId: String, userId: String, changeFeedbackRequest: ChangeFeedbackRequestDto) async {
        if let index = feedbacks.firstIndex(where: { $0.id == userId && $0.meditationId == practiceId }) {
            // Создаем копию элемента с обновленными полями
            var updatedFeedback = feedbacks[index]
            updatedFeedback.comment = changeFeedbackRequest.comment
            updatedFeedback.estimate = changeFeedbackRequest.estimate
            
            // Заменяем элемент в массиве
            feedbacks[index] = updatedFeedback
        }

        let endPoint = "\(EndPoints.AddPracticeFeedback)/\(practiceId)/feedback"
        
        let queryParameters = [
            "userId": userId
        ]
        
        let body = try? JSONEncoder().encode(changeFeedbackRequest)

        
        let result: Result<EmptyResponse, NetworkError> = await NetworkManager.shared.perfomeRequest(
            endPoint: endPoint,
            method: .PUT,
            body: body,
            queryParameters: queryParameters
        )
        
        switch result {
        case .success:
            print("ok!")
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
    
    // MARK: Delete methods
    func deleteFeedback(practiceId: String, userId: String) async {
        feedbacks.removeAll {
            $0.meditationId == practiceId && $0.id == userId
        }

        let endPoint = "\(EndPoints.AddPracticeFeedback)/\(practiceId)/feedback"
        
        let queryParameters = [
            "userId": userId
        ]
        
        let result: Result<EmptyResponse, NetworkError> = await NetworkManager.shared.perfomeRequest(
            endPoint: endPoint,
            method: .DELETE,
            queryParameters: queryParameters
        )
        
        switch result {
        case .success:
            print("ok!")
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
    /// Преобразование ответа от сервера в модели отзывов
    private func createFeedbacksModels(feedbacksDtos: [FeedbackResponseDto]) async {
        for feedbackDto in feedbacksDtos {
            guard !feedbacks.contains(where: { $0.id == feedbackDto.userId }) else {
                continue
            }
            
            let feedback = Feedback(
                id: feedbackDto.userId,
                meditationId: feedbackDto.meditationId,
                userName: feedbackDto.userName,
                comment: feedbackDto.comment,
                estimate: feedbackDto.estimate)
            
            feedbacks.append(feedback)
        }
    }
}

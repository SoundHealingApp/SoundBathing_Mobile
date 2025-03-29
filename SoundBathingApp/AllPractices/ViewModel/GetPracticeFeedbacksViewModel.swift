//
//  GetPracticeFeedbacksViewModel.swift
//  SoundBathingApp
//
//  Created by Ирина Печик on 29.03.2025.
//

import Foundation
import SwiftUI

@MainActor
public class GetPracticeFeedbacksViewModel : ObservableObject {
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
    func getPracticeFeedBacks(practiceId: String) async {
        let endPoint = "\(EndPoints.GetPracticeFeedbacks)/\(practiceId)/feedbacks"
        
        let result: Result<[FeedbackDto], NetworkError> = await NetworkManager.shared.perfomeRequest(
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
    
//    func getFeedbackAverageRating() -> Int {
//        
//    }
    
    // MARK: - Private methods
    /// Преобразование ответа от сервера в модели отзывов
    private func createFeedbacksModels(feedbacksDtos: [FeedbackDto]) async {
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

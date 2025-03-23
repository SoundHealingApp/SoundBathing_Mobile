//
//  CreateMeditationViewModel.swift
//  SoundBathingApp
//
//  Created by Ирина Печик on 19.02.2025.
//

import Foundation

@MainActor
class CreatePracticeViewModel: ObservableObject {
    @Published var errorMessage: String? = nil
    @Published var isLoading: Bool = false
    @Published var isSendSuccessfully: Bool = false

    private let endPoint = EndPoints.CreatePractice
    
    func createPractice(request: CreatePracticeRequest) async {
        isLoading = true
        errorMessage = nil
        isSendSuccessfully = false
        
        let parameters: [String: String]
        
        if (request.frequency == "") {
            parameters = [
                "title": request.title,
                "description": request.description,
                "meditationType": "\(request.meditationType.numericValue)",
                "therapeuticPurpose": request.therapeuticPurpose
            ]
        } else {
            parameters = [
                "title": request.title,
                "description": request.description,
                "meditationType": "\(request.meditationType.numericValue)",
                "therapeuticPurpose": request.therapeuticPurpose,
                "frequency": request.frequency,
            ]
        }
        
        let audioFile = FileData(
            data: request.data, // Data для аудиофайла
            fileName: "audio.mp3",
            mimeType: "audio/mpeg"
        )
        
        let imageFile = FileData(
            data: request.image, // Data для изображения
            fileName: "image.jpg",
            mimeType: "image/jpeg"
        )
        
        let multipartFormData = MultipartFormData(
            parameters: parameters,
            files: [
                "audio": audioFile,
                "image": imageFile
            ]
        )
        
        // Выполнение запроса
        let result: Result<EmptyResponse, NetworkError> = await NetworkManager.shared.perfomeRequest(
            endPoint: endPoint,
            method: .POST,
            multipartFormData: multipartFormData
        )
        
        // Обработка результата
        switch result {
        case .success:
            errorMessage = nil
            isSendSuccessfully = true
        case .failure(let error):
            switch error {
            case .serverError(let message):
                self.errorMessage = message
            default:
                self.errorMessage = error.localizedDescription
            }
        }
        
        isLoading = false
    }
}

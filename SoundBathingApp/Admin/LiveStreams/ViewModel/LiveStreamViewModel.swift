//
//  LiveStreamViewModel.swift
//  SoundBathingApp
//
//  Created by Ирина Печик on 12.04.2025.
//

import Foundation
import SwiftUI

@MainActor
class LiveStreamViewModel: ObservableObject {
    @Published var liveStreams: [LiveStream] = []
    @Published var showingAddStream = false
    @Published var editingStream: LiveStream?
    @Published var errorMessage: String? = nil

    /// Добавление и сохранение стрима.
    func addStream(_ stream: LiveStream) async {
        let createLiveStreamRequest = CreateLiveStreamRequestDto(
            title: stream.title,
            description: stream.description,
            therapeuticPurpose: stream.therapeuticPurpose,
            startDateTime: stream.startDateTime.toLocalString(),
            youTubeUrl: stream.youTubeUrl
        )
        
        let endPoint = EndPoints.CreateLiveStream
        
        let body = try? JSONEncoder().encode(createLiveStreamRequest)
        
        let result: Result<EmptyResponse, NetworkError> = await NetworkManager.shared.perfomeRequest(
            endPoint: endPoint,
            method: .POST,
            body: body
        )
        
        switch result {
        case .success:
            liveStreams.append(stream)
            self.errorMessage = nil
            print("Live stream saved")
        case .failure(let error):
            switch error {
            case .serverError(let message):
                self.errorMessage = message
            default:
                self.errorMessage = error.localizedDescription
            }
        }
    }

    /// Получение всех предстоящих стримов.
    func getUpcomingStreams() async {
        let endPoint = EndPoints.GetUpcomingLiveStreams
        
        let result: Result<[LiveStreamResponseDto], NetworkError> = await NetworkManager.shared.perfomeRequest(
            endPoint: endPoint,
            method: .GET
        )
        
        switch result {
            case .success(let liveStreamsDtos):
            createLiveStreamsModels(liveStreamsDtos: liveStreamsDtos)
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
    
    /// Получение  прошедших стримов.
    func getPastStreams() async {
        let endPoint = EndPoints.GetPastLiveStreams
        
        let result: Result<[LiveStreamResponseDto], NetworkError> = await NetworkManager.shared.perfomeRequest(
            endPoint: endPoint,
            method: .GET
        )
        
        switch result {
            case .success(let liveStreamsDtos):
            createLiveStreamsModels(liveStreamsDtos: liveStreamsDtos)
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
    
    /// Получение  прошедших стримов.
    func getNearestStream() async -> LiveStream? {
        let endPoint = EndPoints.GetNearestLiveStream
        
        let result: Result<LiveStreamResponseDto, NetworkError> = await NetworkManager.shared.perfomeRequest(
            endPoint: endPoint,
            method: .GET
        )
        
        switch result {
            case .success(let liveStreamDto):
            self.errorMessage = nil
            return createLiveStreamsModel(liveStreamDto: liveStreamDto)
            case .failure(let error):
                switch error {
                case .serverError(let message):
                    self.errorMessage = message
                    return nil
                default:
                    self.errorMessage = error.localizedDescription
                    return nil
                }
        }
    }
    
    /// Обновление прямого эфира.
    func updateStream(updatedStream: LiveStream) async {
        let endPoint = "\(EndPoints.UpdateLiveStream)/\(updatedStream.id)"

         if let index = liveStreams.firstIndex(where: { $0.id == updatedStream.id }) {
             liveStreams[index] = updatedStream
         }
        
        let updateLiveStreamRequest = UpdateLiveStreamRequestDto(
            title: updatedStream.title,
            description: updatedStream.description,
            therapeuticPurpose: updatedStream.therapeuticPurpose,
            startDateTime: updatedStream.startDateTime.toServerFormat(),
            youTubeUrl: updatedStream.youTubeUrl
        )
        
        let body = try? JSONEncoder().encode(updateLiveStreamRequest)
        
        let result: Result<EmptyResponse, NetworkError> = await NetworkManager.shared.perfomeRequest(
            endPoint: endPoint,
            method: .PATCH,
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
    
    /// Удаление стрима по id.
    func deleteStream(id: String) async {
        await MainActor.run {
            withAnimation(.interactiveSpring(response: 0.3, dampingFraction: 0.7)) {
                liveStreams.removeAll { $0.id == id }
            }
        }
        
        let endPoint = "\(EndPoints.DeleteLiveStream)/\(id)"

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
    private func createLiveStreamsModels(liveStreamsDtos: [LiveStreamResponseDto]) {
        for liveStreamsDto in liveStreamsDtos {
            guard !liveStreams.contains(where: { $0.id == liveStreamsDto.id }) else {
                continue
            }
            
            let liveStream = LiveStream(
                id: liveStreamsDto.id,
                title: liveStreamsDto.title,
                description: liveStreamsDto.description,
                therapeuticPurpose: liveStreamsDto.description,
                startDateTime: liveStreamsDto.formattedStartDateTime.toLocalDateFromServer()!,
                youTubeUrl: liveStreamsDto.youTubeUrl
            )
            
            liveStreams.append(liveStream)
        }
    }
    
    private func createLiveStreamsModel(liveStreamDto: LiveStreamResponseDto) -> LiveStream {
        let liveStream = LiveStream(
            id: liveStreamDto.id,
            title: liveStreamDto.title,
            description: liveStreamDto.description,
            therapeuticPurpose: liveStreamDto.therapeuticPurpose,
            startDateTime: liveStreamDto.formattedStartDateTime.toLocalDateFromServer()!,
            youTubeUrl: liveStreamDto.youTubeUrl
        )
        
        return liveStream
    }
}

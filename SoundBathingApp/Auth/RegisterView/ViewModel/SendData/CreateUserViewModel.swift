//
//  CreateUserViewModel.swift
//  SoundBathingApp
//
//  Created by Ирина Печик on 14.02.2025.
//

import Foundation

@MainActor
class CreateUserViewModel: ObservableObject {
    @Published var errorMessage: String? = nil
    @Published var isLoading: Bool = false
    @Published var isUserCreatedSuccessful: Bool = false

    private let endPoint: String = EndPoints.CreateUser
    
    func sendCreateUserRequestAsync() async {
        isLoading = true
        errorMessage = nil
        
        let id = KeyChainManager.shared.getUserId()
        let name = UserDefaultsManager.shared.getUserName()
        let surname = UserDefaultsManager.shared.getUserSurname()
        let birthDate = UserDefaultsManager.shared.getUserBirthDate()
        
        if (id == nil || name == nil || surname == nil || birthDate == nil) {
            errorMessage = "Not all fields are filled in."
            return
        }
        
        let createUserRequest = CreateUserRequest(
            userId: id!,
            name: name!,
            surname: surname!,
            birthDate: birthDate!)
        
        guard let requestBody = try? JSONEncoder().encode(createUserRequest) else {
            errorMessage = "Failed to encode request body."
            isLoading = false
            return
        }
                
        NetworkManager.shared.perfomeRequest(endPoint: endPoint, method: .POST, body: requestBody) { (result: Result<EmptyResponse, NetworkError>) in
            Task { @MainActor in
                self.isLoading = false
                switch result {
                case .success:
                    self.isUserCreatedSuccessful = true
                case .failure(let error):
                    switch error {
                    case .serverError(let message):
                        self.errorMessage = message
                    default:
                        self.errorMessage = (error.localizedDescription)
                    }
                }
            }
        }
        
    }
}

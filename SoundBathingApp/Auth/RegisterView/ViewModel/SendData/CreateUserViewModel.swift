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
    
    @Published var userId: String = ""

    private let registerEndPoint: String = EndPoints.Register
    private let endPoint: String = EndPoints.CreateUser
    
    func sendCreateUserRequestAsync() async {
        isLoading = true
        errorMessage = nil
        isUserCreatedSuccessful = false

        await RegisterUserAsync()
        await CreateUserDataAsync()
    }
    
    private func RegisterUserAsync() async {
        let email = UserDefaultsManager.shared.getUserEmail()
        let password = KeyChainManager.shared.getUserPasswordHash()
        
        if (email == nil || password == nil) {
            errorMessage = "Email or password are not filled in."
            return
        }
        
        let userRequest = RegisterUserRequest(email: email!, password: password!)
        let body = try? JSONEncoder().encode(userRequest)
        
        let result: Result<RegisterUserResponse, NetworkError> = await NetworkManager.shared.perfomeRequest(
            endPoint: registerEndPoint,
            method: .POST,
            body: body
        )
        
        switch result {
            case .success(let user):
                KeyChainManager.shared.saveToken(user.token)
                self.userId = user.userId
                self.isUserCreatedSuccessful = true
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
    
    private func CreateUserDataAsync() async {
        let name = UserDefaultsManager.shared.getUserName()
        let surname = UserDefaultsManager.shared.getUserSurname()
        let birthDate = UserDefaultsManager.shared.getUserBirthDate()
        
        if (name == nil || surname == nil || birthDate == nil) {
            errorMessage = "Not all fields are filled in."
            return
        }
        
        let createUserRequest = CreateUserRequest(
            userId: userId,
            name: name!,
            surname: surname!,
            birthDate: birthDate!)
        
        guard let requestBody = try? JSONEncoder().encode(createUserRequest) else {
            errorMessage = "Failed to encode request body."
            isLoading = false
            return
        }
        
        let result: Result<EmptyResponse, NetworkError> = await NetworkManager.shared.perfomeRequest(
            endPoint: endPoint,
            method: .POST,
            body: requestBody
        )
        
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
        
        isLoading = false
    }
}

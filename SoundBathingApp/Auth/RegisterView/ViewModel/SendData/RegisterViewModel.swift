//
//  RegisterViewModel.swift
//  SoundBathingApp
//
//  Created by Ирина Печик on 06.02.2025.
//

import SwiftUI

@MainActor
class RegisterViewModel: ObservableObject {
    private(set) var jwtToken: String = ""
    private(set) var userId: String = ""
    private let endPoint: String = EndPoints.Register
    
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published var isRegistrationSuccessful: Bool = false
    
    func sendRequest(email: String, password: String) async {
        isLoading = true
        errorMessage = nil
        
        let userRequest = RegisterUserRequest(email: email, password: password)
        let body = try? JSONEncoder().encode(userRequest)
                
        NetworkManager.shared.perfomeRequest(endPoint: endPoint, method: HttpMethods.POST, body: body) { (result: Result<RegisterUserResponse, NetworkError>) in
            Task { @MainActor in
                self.isLoading = false
                switch result {
                case .success(let user):
                    KeyChainManager.shared.saveToken(user.token)
                    KeyChainManager.shared.saveUserId(user.userId)
                    self.isRegistrationSuccessful = true
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


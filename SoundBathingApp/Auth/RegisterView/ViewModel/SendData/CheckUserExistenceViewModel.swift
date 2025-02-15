//
//  RegisterViewModel.swift
//  SoundBathingApp
//
//  Created by Ирина Печик on 06.02.2025.
//

import SwiftUI

@MainActor
class CheckUserExistenceViewModel: ObservableObject {
    private(set) var jwtToken: String = ""
    private(set) var userId: String = ""
    private let endPoint: String = EndPoints.CheckUserExistence
    
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published var isCheckedSuccessful: Bool = false
    
    func checkUserExistence(email: String, password: String) async {
        isLoading = true
        errorMessage = nil
        isCheckedSuccessful = false
        
        let queryParameters = [
            "email": email
        ]
        
        let result: Result<EmptyResponse, NetworkError> = await NetworkManager.shared.perfomeRequest(
            endPoint: endPoint,
            method: .GET,
            queryParameters: queryParameters
        )
        
        switch result {
            case .success(_):
                KeyChainManager.shared.saveUserPasswordHash(password)
                UserDefaultsManager.shared.saveUserEmail(email: email)
                self.isCheckedSuccessful = true
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


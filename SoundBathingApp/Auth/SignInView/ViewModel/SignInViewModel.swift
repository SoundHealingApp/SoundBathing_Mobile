//
//  SignInViewModel.swift
//  SoundBathingApp
//
//  Created by Ирина Печик on 15.02.2025.
//

import Foundation

@MainActor
class SignInViewModel: ObservableObject {
    @Published var errorMessage: String? = nil
    @Published var isLoading: Bool = false
    @Published var isSignedInSuccessfully: Bool = false
    
    private let endPoint: String = EndPoints.SignIn
    private var email: String = ""
    private var password: String = ""
    
    func sendSignInRequestAsync(email: String, password: String) async {
        isLoading = true
        errorMessage = nil
        isSignedInSuccessfully = false
        
        self.email = email
        self.password = password

        await signInAsync()
    }
    
    private func signInAsync() async {
        let signInRequest = SignInRequest(email: email, password: password)
        let body = try? JSONEncoder().encode(signInRequest)
        
        let result: Result<SignInResponse, NetworkError> = await NetworkManager.shared.perfomeRequest(
            endPoint: endPoint,
            method: .POST,
            body: body
        )
        
        switch result {
            case .success(let user):
                KeyChainManager.shared.saveToken(user.token)
                KeyChainManager.shared.saveUserId(user.userId)
                isSignedInSuccessfully = true
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

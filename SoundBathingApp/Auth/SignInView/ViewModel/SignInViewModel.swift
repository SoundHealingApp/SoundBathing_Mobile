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
            
    private var userId: String = ""
    
    func sendDeleteAccountRequest(id: String) async {
        await deleteUser(id: id)
    }
    
    func sendSignInRequestAsync(email: String, password: String) async {
        isLoading = true
        errorMessage = nil
        isSignedInSuccessfully = false
        
        let hashedPassword = AuthHelper.hashPassword(password)

        await signInAsync(email: email, hashedPassword: hashedPassword)
        await getUserData(id: userId)
    }
    
    private func deleteUser(id: String) async {
        let endPoint: String = "\(EndPoints.DeleteUserByUserId)/\(id)"

        let result: Result<EmptyResponse, NetworkError> = await NetworkManager.shared.perfomeRequest(
            endPoint: endPoint,
            method: .DELETE)
        
        switch result {
            case .success:
                print("Deleted successfully")
            case .failure(let error):
                switch error {
                case .serverError(let message):
                    self.errorMessage = message
                default:
                    self.errorMessage = error.localizedDescription
                }
            }
    }
    
    private func getUserData(id: String) async {
        let endPoint: String = "\(EndPoints.GetUserDataByUserId)/\(id)"

        let result: Result<GetUserDataResponse, NetworkError> = await NetworkManager.shared.perfomeRequest(
            endPoint: endPoint,
            method: .GET)
        
        switch result {
            case .success(let user):
                UserDefaultsManager.shared.saveUserName(name: user.name)
                UserDefaultsManager.shared.saveUserSurname(surname: user.surname)
                UserDefaultsManager.shared.saveUserBirthDate(birthDate: user.birthDate)
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
    
    private func signInAsync(email: String, hashedPassword: String) async {
        let endPoint: String = EndPoints.SignIn

        let signInRequest = SignInRequest(email: email, hashedPassword: hashedPassword)
        let body = try? JSONEncoder().encode(signInRequest)
        
        let result: Result<SignInResponse, NetworkError> = await NetworkManager.shared.perfomeRequest(
            endPoint: endPoint,
            method: .POST,
            body: body
        )
        
        switch result {
            case .success(let user):
                userId = user.userId
                UserDefaultsManager.shared.setUserRegistered()
                KeyChainManager.shared.saveToken(user.token)
                KeyChainManager.shared.saveUserId(user.userId)
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

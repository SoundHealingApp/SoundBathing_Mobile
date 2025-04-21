//
//  UserPermissionsViewModel.swift
//  SoundBathingApp
//
//  Created by Ирина Печик on 20.04.2025.
//

import Foundation

@MainActor
class UserPermissionsViewModel : ObservableObject {
    
    public func CanCurrentUserManagePracticesAsync() async -> Bool {
        let userId = KeyChainManager.shared.getUserId()
        let requiredPermission = Permissions.MeditationsAdministration
        
        let hasPermission = await CheckUserPermissionsAsync(
            userId: userId!,
            permissionName: requiredPermission
        )
        
        return hasPermission
    }
    
    public func CanCurrentUserManageQuotesAsync() async -> Bool {
        let userId = KeyChainManager.shared.getUserId()
        let requiredPermission = Permissions.QuotesAdministration
        
        let hasPermission = await CheckUserPermissionsAsync(
            userId: userId!,
            permissionName: requiredPermission
        )
        
        return hasPermission
    }
    
    public func CanCurrentUserManageLiveStreamsAsync() async -> Bool {
        let userId = KeyChainManager.shared.getUserId()
        let requiredPermission = Permissions.LiveStreamsAdministration
        
        let hasPermission = await CheckUserPermissionsAsync(
            userId: userId!,
            permissionName: requiredPermission
        )
        
        return hasPermission
    }

    // MARK: - Private methods
    private func CheckUserPermissionsAsync(userId: String, permissionName: Permissions) async -> Bool {
        let endPoint = "\(EndPoints.HasPermission)/\(userId)/has-permission"
        
        let queryParameters = [
            "permissionName": permissionName.rawValue
        ]
        
        let result: Result<Bool, NetworkError> = await NetworkManager.shared.perfomeRequest(
            endPoint: endPoint,
            method: .GET,
            queryParameters: queryParameters
        )
        
        switch result {
        case .success(let hasAccess):
            return hasAccess
        case .failure(let error):
            switch error {
            case .serverError(let message):
                print(message)
            default:
                print(error.localizedDescription)
            }
        }
        
        return false
    }
}

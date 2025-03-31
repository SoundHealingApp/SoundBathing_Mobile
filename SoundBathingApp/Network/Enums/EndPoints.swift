//
//  EndPoints.swift
//  SoundBathingApp
//
//  Created by Ирина Печик on 14.02.2025.
//

import Foundation

// MARK: Do not forget to past '/' before the path!!!!!
class EndPoints {
    // MARK: - User
    static let Register: String = "/auth/register"
    static let SignIn: String = "/auth/login"
    static let CheckUserExistence: String = "/auth/user"
    static let CreateUser: String = "/users"
    
    // MARK: Practices
    static let CreatePractice: String = "/api/meditations"
    static let GetPracticesByType: String = "/api/meditations/type"
    static let DownloadPracticeImage: String = "/api/meditations"
    
    // MARK: Practice's likes
    static let GetLikedPractices: String = "liked-meditations"
    
    // MARK: Practice's feedbacks
    static let GetPracticeFeedbacks: String = "/api/meditations"
    static let AddPracticeFeedback: String = "/api/meditations"
}

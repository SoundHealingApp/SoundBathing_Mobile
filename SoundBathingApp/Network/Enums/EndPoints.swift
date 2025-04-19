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
    static let ChangeUserData: String = "/users"
    
    // MARK: Practices
    static let CreatePractice: String = "/api/meditations"
    static let GetPracticesByType: String = "/api/meditations/type"
    static let DownloadPracticeImage: String = "/api/meditations"
    static let DownloadPracticeAudio: String = "/api/meditations"

    // MARK: Practice's likes
    static let GetLikedPractices: String = "liked-meditations"
    
    // MARK: Practice's feedbacks
    static let GetPracticeFeedbacks: String = "/api/meditations"
    static let AddPracticeFeedback: String = "/api/meditations"
    
    // MARK: Quotes
    static let CreateQuote: String = "/api/quotes"
    static let GetQuotes: String = "/api/quotes"
    static let GetRandomQuote: String = "/api/quotes/random"
    static let UpdateQuote: String = "/api/quotes"
    static let DeleteQuote: String = "/api/quotes"

    // MARK: Live Streams
    static let CreateLiveStream: String = "/api/livestreams"
    static let GetUpcomingLiveStreams: String = "/api/livestreams/upcoming"
    static let GetPastLiveStreams: String = "/api/livestreams/past"
    static let UpdateLiveStream: String = "/api/livestreams"
    static let DeleteLiveStream: String = "/api/livestreams"
    
    // MARK: Recommended practices
    static let AddPracticesToRecommended: String = "/api/users"
    static let GetRecommendedPractices: String = "/api/users"

}

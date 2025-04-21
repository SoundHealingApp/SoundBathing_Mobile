//
//  Permissions.swift
//  SoundBathingApp
//
//  Created by Ирина Печик on 20.04.2025.
//

import Foundation

enum Permissions: String {
    case GetUserInfo = "GetUserInfo"
    case EditUserInfo = "EditUserInfo"
    case GetLiveStreamsInfo = "GetLiveStreamsInfo"
    case GetMeditationsInfo = "GetMeditationsInfo"
    case GetQuotesInfo = "GetQuotesInfo"
    case AddFeedback = "AddFeedback"
    case GetFeedbackInfo = "GetFeedbackInfo"
    case ManageMeditationsLikes = "ManageMeditationsLikes"
    case ManageMeditationsRecommendations = "ManageMeditationsRecommendations"
    case LiveStreamsAdministration = "LiveStreamsAdministration"
    case MeditationsAdministration = "MeditationsAdministration"
    case QuotesAdministration = "QuotesAdministration"
}

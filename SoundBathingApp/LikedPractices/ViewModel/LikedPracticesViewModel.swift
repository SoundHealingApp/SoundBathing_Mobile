////
////  LikedPracticesViewModel.swift
////  SoundBathingApp
////
////  Created by Ирина Печик on 23.03.2025.
////
//
//import Foundation
//
//@MainActor
//class LikedPracticesViewModel: ObservableObject {
//    @Published var errorMessage: String? = nil
//    @Published var isLoading: Bool = false
//    @Published var likedPractices: Set<Practice> = []
//    
//    func getLikedPractices() async {
//        let userId = KeyChainManager.shared.getUserId()
//        
//        let endPoint = "/users/\(String(describing: userId)))/\(EndPoints.GetLikedPractices)"
//        
//        let result: Result<[PracticeDto], NetworkError> = await NetworkManager.shared.perfomeRequest(
//            endPoint: endPoint,
//            method: .GET
//        )
//        
//        
//    }
//}

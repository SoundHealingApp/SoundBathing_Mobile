//
//  NetworkError.swift
//  SoundBathingApp
//
//  Created by Ирина Печик on 07.02.2025.
//

enum NetworkError: Error {
    case invalidUrl
    case nullData
    case decodableError
    case serverError(String)
    case networkError(String)
    case imageDecodingError
    case authenticationError
}

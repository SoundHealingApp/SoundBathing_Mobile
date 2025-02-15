//
//  NetworkManager.swift
//  SoundBathingApp
//
//  Created by Ирина Печик on 06.02.2025.
//

import Foundation

class NetworkManager: NSObject, URLSessionDelegate {
    static let shared = NetworkManager()
    private let host = "http://localhost:5046"
    
    // MARK: - Выполнение запроса
    func perfomeRequest<T: Codable>(
        endPoint: String,
        method: HttpMethods,
        body: Data? = nil,
        queryParameters: [String: String]? = nil) async -> Result<T, NetworkError>
    {
        guard let url = URL(string: "\(host)\(endPoint)") else {
            return .failure(.invalidUrl)
        }
        
        let request = createRequest(url: url, method: method, body: body, queryParameters: queryParameters)
            
        let session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
        
        do {
            let (data, response) = try await session.data(for: request)
            
            // Проверка на валидный HTTP-ответ
            guard let httpResponse = response as? HTTPURLResponse else {
                return .failure(.serverError("Invalid response"))
            }
            
            // Обработка статус кода
            if (200...299).contains(httpResponse.statusCode) {
                if T.self == EmptyResponse.self {
                    // Если ожидаемый тип — Void, просто возвращаем успех
                    return .success(EmptyResponse() as! T)
                }
                else if !data.isEmpty {
                    // Если есть данные, пытаемся их декодировать
                    do {
                        let decodedData = try JSONDecoder().decode(T.self, from: data)
                        return .success(decodedData)
                    } catch {
                        return .failure(.decodableError)
                    }
                } else {
                    // Если данных нет, но тип не Void, возвращаем ошибку
                    return .failure(.nullData)
                }
            } else {
                // Обработка ошибки
                if !data.isEmpty {
                    if let errorResponse = try? JSONDecoder().decode(ServerErrorResponse.self, from: data) {
                        return .failure(.serverError(errorResponse.detail))
                    } else {
                        return .failure(.serverError("Something went wrong"))
                    }
                } else {
                    return .failure(.serverError("No data received"))
                }
            }
            
        } catch {
            // Обработка ошибки сети
            return .failure(.networkError(error.localizedDescription))
        }
    }
    // MARK: - Создание запроса
    private func createRequest(
        url: URL,
        method: HttpMethods,
        body: Data? = nil,
        queryParameters: [String: String]? = nil) -> URLRequest {
        // Создаем компоненты URL для добавления query-параметров
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
            
        // Добавляем query-параметры, если они есть
        if let queryParameters = queryParameters {
            urlComponents?.queryItems = queryParameters.map { key, value in
                URLQueryItem(name: key, value: value)
            }
        }
        // Получаем итоговый URL с query-параметрами
        guard let finalURL = urlComponents?.url else {
            fatalError("Failed to create URL with query parameters")
        }
            
        var request = URLRequest(url: finalURL)
        request.httpMethod = method.rawValue;
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Добавляем токен в хэдеры, если он есть.
        if let token = KeyChainManager.shared.getToken() {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        if let body = body {
            request.httpBody = body
        }
        
        return request
    }
    
    // MARK: - Заглушка проверки сертификата
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust,
           let serverTrust = challenge.protectionSpace.serverTrust,
           challenge.protectionSpace.host == "localhost" {
            let credential = URLCredential(trust: serverTrust)
            completionHandler(.useCredential, credential)
            return
        }
        completionHandler(.performDefaultHandling, nil)
    }
}

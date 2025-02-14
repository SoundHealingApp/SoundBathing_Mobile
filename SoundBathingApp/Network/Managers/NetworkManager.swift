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
        completion: @escaping (Result<T, NetworkError>) -> Void) {
        
        guard let url = URL(string: "\(host)\(endPoint)") else {
            completion(.failure(.invalidUrl))
            return
        }
        
        let request = createRequest(url: url, method: method, body: body)
        let session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
        
        session.dataTask(with: request) { data, response, error in
            // Проверка на ошибку сети
            if let error = error {
                completion(.failure(.networkError(error.localizedDescription)))
                return
            }
            
            // Проверка на валидный HTTP-ответ
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.serverError("Invalid response")))
                return
            }
            
            print(httpResponse.statusCode)
            
            // Обработка статус кода
            if (200...299).contains(httpResponse.statusCode) {
                if T.self == EmptyResponse.self {
                    // Если ожидаемый тип — Void, просто возвращаем успех
                    completion(.success(EmptyResponse() as! T))
                }
                else if let data = data, !data.isEmpty {
                    // Если есть данные, пытаемся их декодировать
                    do {
                        let decodedData = try JSONDecoder().decode(T.self, from: data)
                        completion(.success(decodedData))
                    } catch {
                        completion(.failure(.decodableError))
                    }
                } else {
                    // Если данных нет, но тип не Void, возвращаем ошибку
                    completion(.failure(.nullData))
                }
            } else {
                // Обработка ошибки
                if let data = data, !data.isEmpty {
                    if let errorResponse = try? JSONDecoder().decode(ServerErrorResponse.self, from: data) {
                        completion(.failure(.serverError(errorResponse.detail)))
                    } else {
                        completion(.failure(.serverError("Something went wrong")))
                    }
                } else {
                    completion(.failure(.serverError("No data received")))
                }
            }
        }
        .resume()
    }
        
    // MARK: - Создание запроса
    private func createRequest(url: URL, method: HttpMethods, body: Data? = nil) -> URLRequest {
        var request = URLRequest(url: url)
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

//
//  NetworkManager.swift
//  SoundBathingApp
//
//  Created by Ирина Печик on 06.02.2025.
//

import Foundation
import UIKit

class NetworkManager: NSObject, URLSessionDelegate {
    static let shared = NetworkManager()
    private let host = "http://localhost:5046"

    // MARK: - Выполнение запроса
    func perfomeRequest<T: Codable>(
        endPoint: String,
        method: HttpMethods,
        body: Data? = nil,
        queryParameters: [String: Any]? = nil,
        multipartFormData: MultipartFormData? = nil) async -> Result<T, NetworkError>
    {
        guard let url = URL(string: "\(host)\(endPoint)") else {
            return .failure(.invalidUrl)
        }
        
        
        let request: URLRequest
        if let multiData = multipartFormData {
            // Создаем multipart/form-data запрос
            request = createMultipartFormDataRequest(
                url: url,
                method: method,
                multipartFormData: multiData)
        } else {
            request = createRequest(
                url: url,
                method: method,
                body: body,
                queryParameters: queryParameters)
        }
        
        print(requestDescription(request))
        print("""
        🌐 Request Debug Info:
        URL: \(url)
        Method: \(method.rawValue)
        Token exists: \(KeyChainManager.shared.getToken() != nil)
        Headers: \(request.allHTTPHeaderFields ?? [:])
        Body: \(body != nil ? String(data: body!, encoding: .utf8) ?? "nil" : "nil")
        """)
        let session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
        
        do {
            let (data, response) = try await session.data(for: request)
            
            print(responseDescription(response, data)) // Лог ответа сервера
            
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
    
    // MARK: - Загрузка изображения
    func downloadImage(from endPoint: String) async -> Result<UIImage, NetworkError> {
        guard let url = URL(string: "\(host)\(endPoint)") else {
            return .failure(.invalidUrl)
        }

        var request = URLRequest(url: url)
        request.httpMethod = HttpMethods.GET.rawValue

        if let token = KeyChainManager.shared.getToken() {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        let session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)

        do {
            let (data, response) = try await session.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                return .failure(.serverError("Invalid response"))
            }

            if (200...299).contains(httpResponse.statusCode) {
                if let image = UIImage(data: data) {
                    return .success(image)
                } else {
                    return .failure(.imageDecodingError)
                }
            } else {
                return .failure(.serverError("Failed to download image, status code: \(httpResponse.statusCode)"))
            }
        } catch {
            return .failure(.networkError(error.localizedDescription))
        }
    }
    
    // MARK: - Загрузка аудио
    func downloadAudio(from endPoint: String) async -> Result<Data, NetworkError> {
        guard let url = URL(string: "\(host)\(endPoint)") else {
            return .failure(.invalidUrl)
        }

        var request = URLRequest(url: url)
        request.httpMethod = HttpMethods.GET.rawValue

        if let token = KeyChainManager.shared.getToken() {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        let session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)

        do {
            let (data, response) = try await session.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                return .failure(.serverError("Invalid response"))
            }

            if (200...299).contains(httpResponse.statusCode) {
                return .success(data)
            } else {
                return .failure(.serverError("Failed to download audio, status code: \(httpResponse.statusCode)"))
            }
        } catch {
            return .failure(.networkError(error.localizedDescription))
        }
    }
    
    // MARK: - Создание обычного запроса (JSON)
    private func createRequest(
        url: URL,
        method: HttpMethods,
        body: Data? = nil,
        queryParameters: [String: Any]? = nil) -> URLRequest {
        // Создаем компоненты URL для добавления query-параметров
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
            
        // Добавляем query-параметры, если они есть
        if let queryParameters = queryParameters {
            urlComponents?.queryItems = createQueryItems(from: queryParameters)
        }
            
        // Получаем итоговый URL с query-параметрами
        guard let finalURL = urlComponents?.url else {
            fatalError("Failed to create URL with query parameters")
        }
            
        var request = URLRequest(url: finalURL)
        request.httpMethod = method.rawValue;
            
        if method != .GET {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }

        // Добавляем токен в хэдеры, если он есть.
        if let token = KeyChainManager.shared.getToken() {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        request.setValue("*/*", forHTTPHeaderField: "Accept")
        request.setValue("gzip, deflate, br", forHTTPHeaderField: "Accept-Encoding")
        request.setValue("keep-alive", forHTTPHeaderField: "Connection")
            
        if let body = body {
            request.httpBody = body
        }
        
        return request
    }
    
    private func createQueryItems(from parameters: [String: Any])  -> [URLQueryItem] {
        var queryItems = [URLQueryItem]()
        
        for (key, value) in parameters {
            if let stringValue = value as? String {
                queryItems.append(URLQueryItem(name: key, value: stringValue))
            }
            else if let arrayValue = value as? [String] {
                // Для массива добавляем несколько параметров с одним ключом
                arrayValue.forEach {
                    queryItems.append(URLQueryItem(name: key, value: $0))
                }
            }
            else if let dictValue = value as? [String: [String]] {
                // Для словаря с массивами
                for (subKey, subArray) in dictValue {
                    subArray.forEach {
                        queryItems.append(URLQueryItem(name: "\(key)[\(subKey)]", value: $0))
                    }
                }
            }
        }
        
        return queryItems
    }
    
    // MARK: - Создание multipart/form-data запроса
    private func createMultipartFormDataRequest(
        url: URL,
        method: HttpMethods,
        multipartFormData: MultipartFormData) -> URLRequest {
            
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        // Устанавливаем границу для multipart/form-data
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        // Создаем тело запроса
        var body = Data()
        
        // Добавляем текстовые поля
        for (key, value) in multipartFormData.parameters {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
            body.append("\(value)\r\n".data(using: .utf8)!)
        }
        
        // Добавляем файлы
        for (key, fileData) in multipartFormData.files {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(fileData.fileName)\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: \(fileData.mimeType)\r\n\r\n".data(using: .utf8)!)
            body.append(fileData.data)
            body.append("\r\n".data(using: .utf8)!)
        }
        
        // Завершаем тело запроса
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        // Устанавливаем тело запроса
        request.httpBody = body
        
        // Добавляем токен в заголовки, если он есть
        if let token = KeyChainManager.shared.getToken() {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        return request
    }
    
    // MARK: - Заглушка проверки сертификата
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        let host = challenge.protectionSpace.host
        print("🔐 Handling SSL challenge for:", host)
        
        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust,
           let serverTrust = challenge.protectionSpace.serverTrust {
            
            // Разрешаем оба варианта локального хоста
            if ["localhost", "127.0.0.1"].contains(host) {
                print("✅ Trusting localhost SSL")
                completionHandler(.useCredential, URLCredential(trust: serverTrust))
                return
            }
        }
        completionHandler(.performDefaultHandling, nil)
    }
//    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
//        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust,
//           let serverTrust = challenge.protectionSpace.serverTrust,
//           challenge.protectionSpace.host == "localhost" {
//            let credential = URLCredential(trust: serverTrust)
//            completionHandler(.useCredential, credential)
//            return
//        }
//        completionHandler(.performDefaultHandling, nil)
//    }
    
    // MARK: - Debug methods
    private func requestDescription(_ request: URLRequest) -> String {
        var output = "\n📡 [REQUEST] \(request.httpMethod ?? "UNKNOWN") \(request.url?.absoluteString ?? "NO URL")\n"
        
        // Заголовки
        if let headers = request.allHTTPHeaderFields, !headers.isEmpty {
            output += "📝 Headers:\n"
            for (key, value) in headers {
                output += "   \(key): \(value)\n"
            }
        }
        
        // Тело запроса
        if let body = request.httpBody, let bodyString = String(data: body, encoding: .utf8) {
            output += "📦 Body:\n\(bodyString)\n"
        } else {
            output += "📦 Body: EMPTY\n"
        }
        
        return output
    }
    
    private func responseDescription(_ response: URLResponse?, _ data: Data?) -> String {
        guard let httpResponse = response as? HTTPURLResponse else {
            return "❌ [RESPONSE] Ошибка: нет HTTP-ответа"
        }
        
        var output = "\n✅ [RESPONSE] \(httpResponse.statusCode) \(httpResponse.url?.absoluteString ?? "NO URL")\n"
        
        // Заголовки ответа
        output += "📝 Headers:\n"
        for (key, value) in httpResponse.allHeaderFields {
            output += "   \(key): \(value)\n"
        }
        
        // Данные ответа
        if let data = data, let jsonString = String(data: data, encoding: .utf8) {
            output += "📦 Body:\n\(jsonString)\n"
        } else {
            output += "📦 Body: EMPTY\n"
        }
        
        return output
    }

}

// MARK: - Модель для multipart/form-data
struct MultipartFormData {
    var parameters: [String: String] // Текстовые поля
    var files: [String: FileData] // Файлы
}

struct FileData {
    var data: Data // Данные файла
    var fileName: String // Имя файла
    var mimeType: String // MIME-тип файла
}

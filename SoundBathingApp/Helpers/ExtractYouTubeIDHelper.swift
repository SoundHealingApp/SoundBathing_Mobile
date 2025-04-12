//
//  ExtractYouTubeIDHelper.swift
//  SoundBathingApp
//
//  Created by Ирина Печик on 12.04.2025.
//

import Foundation

struct ExtractYouTubeIDHelper {
    static func extractYouTubeID(from urlString: String) -> String? {
        /// Удаляем лишние пробелы и исправляем возможные проблемы в строке
        let cleanedURL = urlString
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "\\/", with: "/")
        
        // 2. Пытаемся разобрать URL
        guard let url = URL(string: cleanedURL) else {
            // Если это не URL, возможно это уже сам ID (11 символов)
            return urlString.count == 11 ? urlString : nil
        }
        
        // 3. Проверяем разные форматы URL
        
        // Формат 1: Короткие ссылки youtu.be/ID
        if url.host?.contains("youtu.be") == true {
            return url.pathComponents.last
        }
        
        // Формат 2: Обычные ссылки watch?v=ID
        if let queryItems = URLComponents(url: url, resolvingAgainstBaseURL: true)?.queryItems {
            for item in queryItems where item.name == "v" {
                return item.value
            }
        }
        
        // Формат 3: Встроенные видео embed/ID
        if url.pathComponents.contains("embed") {
            return url.pathComponents.last
        }
        
        // Формат 4: Прямые трансляции live/ID
        if url.pathComponents.contains("live") {
            return url.pathComponents.last
        }
        
        // Формат 5: Короткие видео shorts/ID
        if url.pathComponents.contains("shorts") {
            return url.pathComponents.last
        }
        
        // 4. Если URL не распознан, используем регулярное выражение
        let pattern = #"(?:youtu\.be\/|watch\?v=|embed\/|live\/|shorts\/|v\/)([a-zA-Z0-9_-]{11})"#
        if let range = cleanedURL.range(of: pattern, options: .regularExpression) {
            return String(cleanedURL[range].suffix(11))
        }
        
        return nil
    }
}

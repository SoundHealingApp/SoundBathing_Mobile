//
//  LiveStreamCardView.swift
//  SoundBathingApp
//
//  Created by Ирина Печик on 12.04.2025.
//

import SwiftUI

// TODO: мб улучшить дизайн
struct LiveStreamCardView: View {
    let stream: LiveStream
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            YouTubePlayerView(videoID: ExtractYouTubeIDHelper.extractYouTubeID(from: stream.youTubeUrl) ?? "")
                .frame(height: 180)
                .cornerRadius(12)
            
            VStack(alignment: .leading, spacing: 8) {
                Text(stream.title)
                    .font(.headline)
                    .foregroundStyle(.primary)
                
                Text(stream.description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                
                HStack {
                    Image(systemName: "clock")
                    Text(stream.startDateTime.formatted(date: .abbreviated, time: .shortened))
                }
                .font(.caption)
                .foregroundColor(.secondary)
                
                if !stream.therapeuticPurpose.isEmpty {
                    Text(stream.therapeuticPurpose)
                        .font(.caption)
                        .foregroundColor(.indigo)
                        .padding(.vertical, 4)
                        .padding(.horizontal, 8)
                        .background(Color.indigo.opacity(0.1))
                        .cornerRadius(6)
                }
            }
            .padding(.horizontal, 8)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.tertiarySystemBackground))
                .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
        )
    }
    
    /// Извлечение идентификатора видео из URL-адреса.
//    private func extractYouTubeID(from urlString: String) -> String? {
//        
//        /// Удаляем лишние пробелы и исправляем возможные проблемы в строке
//        let cleanedURL = urlString
//            .trimmingCharacters(in: .whitespacesAndNewlines)
//            .replacingOccurrences(of: "\\/", with: "/")
//        
//        // 2. Пытаемся разобрать URL
//        guard let url = URL(string: cleanedURL) else {
//            // Если это не URL, возможно это уже сам ID (11 символов)
//            return urlString.count == 11 ? urlString : nil
//        }
//        
//        // 3. Проверяем разные форматы URL
//        
//        // Формат 1: Короткие ссылки youtu.be/ID
//        if url.host?.contains("youtu.be") == true {
//            return url.pathComponents.last
//        }
//        
//        // Формат 2: Обычные ссылки watch?v=ID
//        if let queryItems = URLComponents(url: url, resolvingAgainstBaseURL: true)?.queryItems {
//            for item in queryItems where item.name == "v" {
//                return item.value
//            }
//        }
//        
//        // Формат 3: Встроенные видео embed/ID
//        if url.pathComponents.contains("embed") {
//            return url.pathComponents.last
//        }
//        
//        // Формат 4: Прямые трансляции live/ID
//        if url.pathComponents.contains("live") {
//            return url.pathComponents.last
//        }
//        
//        // Формат 5: Короткие видео shorts/ID
//        if url.pathComponents.contains("shorts") {
//            return url.pathComponents.last
//        }
//        
//        // 4. Если URL не распознан, используем регулярное выражение
//        let pattern = #"(?:youtu\.be\/|watch\?v=|embed\/|live\/|shorts\/|v\/)([a-zA-Z0-9_-]{11})"#
//        if let range = cleanedURL.range(of: pattern, options: .regularExpression) {
//            return String(cleanedURL[range].suffix(11))
//        }
//        
//        return nil
//    }
}

#Preview {
    LiveStreamCardView(
        stream: LiveStream(
            id: "1",
            title: "Title",
            description: "Description",
            therapeuticPurpose: "Therapeutic Purpose",
            startDateTime: Date.now,
            youTubeUrl: "https://www.youtube.com/live/cPQ0orpEo0g?si=uLYjpdwDX2tzCqnR"
        )
    )
}

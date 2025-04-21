//
//  LiveStreamCardView.swift
//  SoundBathingApp
//
//  Created by Ирина Печик on 12.04.2025.
//

import SwiftUI

struct LiveStreamCardView: View {
    let stream: LiveStream
    
    var isPastStreamByHour: Bool {
        let oneHourAgo = Calendar.current.date(byAdding: .hour, value: -1, to: Date()) ?? Date()
        return stream.startDateTime < oneHourAgo
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            ZStack {
                YouTubePlayerView(videoID: ExtractYouTubeIDHelper.extractYouTubeID(from: stream.youTubeUrl) ?? "")
                    .frame(height: 180)
                    .cornerRadius(12)
                    .overlay(
                        // Если прошёл — затемняем
                        isPastStreamByHour ? Color.black.opacity(0.4).cornerRadius(12) : nil
                    )
                
                if isPastStreamByHour {
                    VStack {
                        Spacer()
                        Text("Stream Ended")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 16)
                            .background(Color.black.opacity(0.7))
                            .cornerRadius(12)
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .frame(height: 180)

            
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
                    Text(stream.startDateTime.toLocalString())
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

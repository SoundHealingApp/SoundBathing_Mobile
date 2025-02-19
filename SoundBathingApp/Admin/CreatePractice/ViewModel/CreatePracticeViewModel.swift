//
//  CreateMeditationViewModel.swift
//  SoundBathingApp
//
//  Created by Ирина Печик on 19.02.2025.
//

import Foundation
import AVFAudio

class CreatePracticeViewModel: ObservableObject {
    @Published var song: PracticeSongModel? = nil
    @Published var audionPlayer: AVAudioPlayer?
    @Published var isPlaying = false
    
    // MARK: - Methods
    func playAudio(practiceSong: PracticeSongModel) {
        do {
            self.audionPlayer = try AVAudioPlayer(data: practiceSong.data)
            self.audionPlayer?.play()
            isPlaying = true
        } catch {
            print("Error in audio playback: \(error.localizedDescription)")
        }
    }
    
    func formateDuration(duration: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        
        formatter.allowedUnits = [.minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        
        return formatter.string(from: duration) ?? ""
    }
}

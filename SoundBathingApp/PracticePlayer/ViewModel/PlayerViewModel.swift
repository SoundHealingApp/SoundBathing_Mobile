//
//  PlayerViewModel.swift
//  SoundBathingApp
//
//  Created by Ирина Печик on 18.02.2025.
//

import Foundation
import AVFAudio

class PlayerViewModel: ObservableObject {
    @Published var audionPlayer: AVAudioPlayer?
    @Published var isPlaying = false
    @Published var currentTime: TimeInterval = 0.0
    @Published var totalTime: TimeInterval = 0.0
    
    // MARK: - Methods
    func getAudioInfo(song: Data) {
        do {
            self.audionPlayer = try AVAudioPlayer(data: song)
            totalTime = audionPlayer?.duration ?? 0.0
        } catch {
            print("Error while getting audio info")
        }
    }
    
    func playPauseAudio() {
        if isPlaying {
            self.audionPlayer?.pause()
        } else {
            self.audionPlayer?.play()
        }
        isPlaying.toggle()
    }
    
    func seekAudio(time: TimeInterval) {
        audionPlayer?.currentTime = time
    }
    
    func updateProgress() {
        guard let player = audionPlayer else { return }
        currentTime = player.currentTime
        isPlaying = player.isPlaying
    }
    
    func formateDuration(duration: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        
        formatter.allowedUnits = [.minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        
        return formatter.string(from: duration) ?? ""
    }

}

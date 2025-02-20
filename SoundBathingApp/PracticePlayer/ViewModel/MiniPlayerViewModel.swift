//
//  PlayerViewModel.swift
//  SoundBathingApp
//
//  Created by Ирина Печик on 18.02.2025.
//

import Foundation
import AVFAudio

class MiniPlayerViewModel: ObservableObject {
//    @Published var song: PracticeSongModel? = nil
    @Published var audionPlayer: AVAudioPlayer?
    @Published var isPlaying = false
    
    // MARK: - Methods
    func playAudio(song: Data) {
        do {
            self.audionPlayer = try AVAudioPlayer(data: song)
            if isPlaying {
                self.audionPlayer?.pause()
            } else {
                self.audionPlayer?.play()
            }
            isPlaying.toggle()
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

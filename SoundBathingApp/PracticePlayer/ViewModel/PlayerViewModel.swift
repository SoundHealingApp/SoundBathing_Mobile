//
//  PlayerViewModel.swift
//  SoundBathingApp
//
//  Created by Ирина Печик on 18.02.2025.
//

import Foundation
import AVFAudio
import UIKit
import MediaPlayer

class PlayerViewModel: ObservableObject {
    static let shared = PlayerViewModel()
    
    @Published var isPlaying = false
    @Published var currentTime: TimeInterval = 0.0
    @Published var totalTime: TimeInterval = 0.0
    
    @Published var audio: Data?
    @Published var title: String = ""
    @Published var therapeuticPurpose: String = ""
    @Published var frequency: String = ""
    @Published var practiceId: String = ""
    @Published var image: UIImage?
    @Published var isFullPlayerPresented: Bool = false
    @Published var isShowingFullPlayer: Bool = false

    private var audionPlayer: AVAudioPlayer?
    
    private init() {}
    
    var hasActivePractice: Bool {
        !practiceId.isEmpty
    }
    
    // MARK: - Methods
    func configure(with practice: Practice, audio: Data) {
        try? AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
        try? AVAudioSession.sharedInstance().setActive(true)
        
        self.audio = audio

        do {
            
            self.audionPlayer = try AVAudioPlayer(data: audio)
            self.audionPlayer?.prepareToPlay()
            self.totalTime = audionPlayer?.duration ?? 0

            // Сохраняем информацию о треке
            self.title = practice.title
            self.image = practice.image
            self.therapeuticPurpose = practice.therapeuticPurpose
            self.frequency = practice.frequency != nil ? String(format: "%.1f Hz", practice.frequency!) : ""
            self.practiceId = practice.id
            
            setupRemoteTransportControls()
            setupNowPlayingInfo()
            
        } catch {
            print("Ошибка воспроизведения: \(error)")
        }
    }
    
    func setupNowPlayingInfo() {
        var nowPlayingInfo: [String: Any] = [
            MPMediaItemPropertyTitle: title, // Название практики
            MPMediaItemPropertyArtist: therapeuticPurpose, // Терапевтическая цель
            MPMediaItemPropertyAlbumTitle: frequency, // Частота
            MPMediaItemPropertyPlaybackDuration: totalTime,
            MPNowPlayingInfoPropertyElapsedPlaybackTime: currentTime,
            MPNowPlayingInfoPropertyPlaybackRate: isPlaying ? 1.0 : 0.0
        ]

        if let image = image {
            let artwork = MPMediaItemArtwork(boundsSize: CGSize(width: 600, height: 600)) { _ in
                return image
            }
            nowPlayingInfo[MPMediaItemPropertyArtwork] = artwork
        }

        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }

    
    func getAudioInfo(song: Data?, title: String, image: UIImage?, therapeuticPurpose: String, frequency: String, practiceId: String) {
        // Настройка AVAudioSession
        try? AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
        try? AVAudioSession.sharedInstance().setActive(true)

        guard let song = song else { return }

        do {
            self.audionPlayer = try AVAudioPlayer(data: song)
            self.audionPlayer?.prepareToPlay()
            self.totalTime = audionPlayer?.duration ?? 0

            // Сохраняем информацию о треке
            self.title = title
            self.image = image
            self.therapeuticPurpose = therapeuticPurpose
            self.frequency = frequency
            self.practiceId = practiceId
        } catch {
            print("Ошибка воспроизведения: \(error)")
        }
    }
    
    func playPauseAudio() {
        if isPlaying {
            self.audionPlayer?.pause()
        } else {
            self.audionPlayer?.play()
        }
        isPlaying.toggle()
        setupNowPlayingInfo()
    }
    
    func resetAndPlayNewAudio() {
        if isPlaying {
            self.audionPlayer?.pause()
            self.audionPlayer?.play()
            isPlaying = true
        } else {
            self.audionPlayer?.play()
            isPlaying = true
        }        
    }
    
    func stopAudio() {
        self.audionPlayer?.pause()
        isPlaying = false
    }
    
    func seekAudio(time: TimeInterval) {
        audionPlayer?.currentTime = time
    }
    
    func updateProgress() {
        guard let player = audionPlayer else { return }
        currentTime = player.currentTime
        isPlaying = player.isPlaying
        setupNowPlayingInfo()
    }
    
    func formateDuration(duration: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        
        formatter.allowedUnits = [.minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        
        return formatter.string(from: duration) ?? ""
    }
    
    func setupRemoteTransportControls() {
        let commandCenter = MPRemoteCommandCenter.shared()

        commandCenter.playCommand.addTarget { [unowned self] _ in
            if !isPlaying {
                playPauseAudio()
                return .success
            }
            return .commandFailed
        }

        commandCenter.pauseCommand.addTarget { [unowned self] _ in
            if isPlaying {
                playPauseAudio()
                return .success
            }
            return .commandFailed
        }

        commandCenter.changePlaybackPositionCommand.isEnabled = true
        commandCenter.changePlaybackPositionCommand.addTarget { [unowned self] event in
            if let positionEvent = event as? MPChangePlaybackPositionCommandEvent {
                seekAudio(time: positionEvent.positionTime)
                return .success
            }
            return .commandFailed
        }
    }


}

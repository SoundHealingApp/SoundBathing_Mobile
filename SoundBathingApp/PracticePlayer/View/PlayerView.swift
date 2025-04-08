//
//  PlayerView.swift
//  SoundBathingApp
//
//  Created by Ирина Печик on 18.02.2025.
//

import SwiftUI

/// Вью для звукового представления.
struct PlayerView: View {
    @StateObject var vm = PlayerViewModel()
    @State var showFullPlayer = false
    
    @Binding var audio: Data
    @Binding var image: UIImage?
    @Binding var title: String
    @Binding var therapeuticPurpose: String
    @Binding var frequency: String
    var isCompact: Bool = false

    @Namespace private var playerAnimation
    
    var frameImage: CGFloat = 320
    
    var body: some View {
        FullPlayer()
            .onAppear {
                vm.getAudioInfo(song: audio)
            }
            .onChange(of: audio) { _, newAudio in
                vm.getAudioInfo(song: newAudio)
            }
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    BackButtonView()
                        .padding(.leading, 10)
                }
            }
    }
    
    // MARK: - Methods
    /// Расскрывающийся большой плейер
    @ViewBuilder
    private func FullPlayer() -> some View {
        ZStack {
            SongImageView(image: image)
            
            VStack {
                SongDescription()
                    .padding(.top, 60)
                
                Spacer()

                VStack(spacing: 30) {
                    /// Ползунок времени
                    ProgressSlider()
                    
                    /// Кнопки управления
                    HStack(spacing: 40) {
                        /// Перемотка назад на 15 сек
                        CustomButton(image: "gobackward.15", size: .system(size: 24)) {
                            vm.seekAudio(time: max(0, vm.currentTime - 15))
                        }
                        
                        /// Основная кнопка Play/Pause
                        CustomButton(
                            image: vm.isPlaying ? "pause.fill" : "play.fill",
                            size: .system(size: 34)
                        ) {
                            vm.playPauseAudio()
                        }
                        
                        /// Перемотка вперед на 15 сек
                        CustomButton(image: "goforward.15", size: .system(size: 24)) {
                            vm.seekAudio(time: min(vm.totalTime, vm.currentTime + 15))
                        }
                    }
                    .padding(.horizontal, 40)
                }
                .padding(.bottom, 50)
            }
            .foregroundStyle(.white)
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
        .onAppear {
            Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                vm.updateProgress()
            }
        }
    }
    
    @ViewBuilder
    private func ProgressSlider() -> some View {
        VStack(spacing: 8) {
            Slider(value: $vm.currentTime, in: 0...vm.totalTime) { editing in
                if !editing {
                    vm.seekAudio(time: vm.currentTime)
                }
            }
            .tint(.white)
            .padding(.horizontal, 40)
            
            HStack {
                Text(vm.formateDuration(duration: vm.currentTime))
                    .font(.system(size: 14, weight: .light))
                
                Spacer()
                
                Text(vm.formateDuration(duration: vm.totalTime))
                    .font(.system(size: 14, weight: .light))
            }
            .padding(.horizontal, 40)
        }
    }
    
    @ViewBuilder
    private func SongDescription() -> some View {
        VStack(spacing: 8) {
            Text(title.isEmpty ? "Title" : title)
                .font(.system(size: 24, weight: .semibold))
                .multilineTextAlignment(.center)
            
            HStack(spacing: 8) {
                Text(therapeuticPurpose.isEmpty ? "Therapeutic purpose" : "\(therapeuticPurpose)")
                    .font(.system(size: 16, weight: .light))
                
                if frequency != "" {
                    HStack(spacing: 4) {
                        Image(systemName: "waveform")
                            .font(.system(size: 14))
                        Text(frequency)
                            .font(.system(size: 16, weight: .light))
                    }
                }
            }
            .opacity(0.85)
        }
        .padding(.horizontal, 40)
    }
    
    @ViewBuilder
    private func SongImageView(image: UIImage?) -> some View {
        if let uiImage = image {
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFill()
                .frame(width: UIScreen.main.bounds.width)
                .opacity(0.3)
                .background(
                    Color.black
                        .opacity(0.95)
                        .cornerRadius(isCompact ? 16 : 0)
                        .padding(isCompact ? 16 : 0)
                )
//                .edgesIgnoringSafeArea(.all)
        }
//        else {
//            Image(systemName: "music.note")
//                .resizable()
//                .scaledToFill()
//                .frame(width: UIScreen.main.bounds.width)
//                .opacity(0.3)
//                .edgesIgnoringSafeArea(.all)
//        }
    }
    
    private func CustomButton(image: String, size: Font, action: @escaping () -> ()) -> some View {
        Button(action: action) {
            Image(systemName: image)
                .font(size)
                .foregroundColor(.white)
                .frame(width: 60, height: 60)
        }
    }
    
    //    @ViewBuilder
    //    private func MiniPlayer() -> some View {
    //        VStack {
    //            HStack {
    //                SongImageView(image: image, size: frameImage)
    //
    //                if !showFullPlayer {
    //                    VStack(alignment: .leading) {
    //                        SongDescription()
    //                    }
    //                    .matchedGeometryEffect(id: "Description", in: playerAnimation)
    //
    //                    Spacer()
    //
    //                    CustomButton(image: vm.isPlaying ? "pause" : "play.fill", size: .headline) {
    //                        vm.playPauseAudio()
    //                    }
    //                    .padding(.trailing)
    //                }
    //            }
    //            .padding(.horizontal, 5)
    //            .padding(.vertical, 5)
    //            .background(showFullPlayer ? .clear : .gray.opacity(0.05))
    //            .clipShape(RoundedRectangle(cornerRadius: 10))
    //
    //            if showFullPlayer {
    //                FullPlayer()
    //            }
    //        }
    //    }
}

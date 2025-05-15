//
//  PlayerView.swift
//  SoundBathingApp
//
//  Created by Ирина Печик on 18.02.2025.
//

import SwiftUI

/// Вью для звукового представления.
struct PlayerView: View {
    @EnvironmentObject var vm: PlayerViewModel
    @State var showHiddenButton: Bool
    var frameImage: CGFloat = 320
    
    var body: some View {
        FullPlayer()
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
        ZStack(alignment: .topLeading)  {
            SongImageView(image: vm.image)
            
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
            
            if showHiddenButton {
                /// Кнопка закрытия
                Button(action: {
                    withAnimation {
                        vm.isShowingFullPlayer = false
                    }
                }) {
                    Image(systemName: "chevron.down")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                        .padding(12)
                }
            }
            
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
        .onAppear {
            Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                vm.updateProgress()
            }
        }
        .onDisappear {
            if !showHiddenButton {
                vm.stopAudio()
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
            Text(vm.title.isEmpty ? "Title" : vm.title)
                .font(.system(size: 24, weight: .semibold))
                .multilineTextAlignment(.center)
            
            HStack(spacing: 8) {
                Text(vm.therapeuticPurpose.isEmpty ? "Therapeutic purpose" : "\(vm.therapeuticPurpose)")
                    .font(.system(size: 16, weight: .light))
                
                if vm.frequency != "" {
                    HStack(spacing: 4) {
                        Image(systemName: "waveform")
                            .font(.system(size: 14))
                        Text(vm.frequency)
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
                        .cornerRadius(0)
                        .padding(0)
//                        .cornerRadius(isCompact ? 16 : 0)
//                        .padding(isCompact ? 16 : 0)
                )
                .edgesIgnoringSafeArea(.all)
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
    
//        @ViewBuilder
//        private func MiniPlayer() -> some View {
//            VStack {
//                HStack {
//                    SongImageView(image: image, size: frameImage)
//    
//                    if !showFullPlayer {
//                        VStack(alignment: .leading) {
//                            SongDescription()
//                        }
//                        .matchedGeometryEffect(id: "Description", in: playerAnimation)
//    
//                        Spacer()
//    
//                        CustomButton(image: vm.isPlaying ? "pause" : "play.fill", size: .headline) {
//                            vm.playPauseAudio()
//                        }
//                        .padding(.trailing)
//                    }
//                }
//                .padding(.horizontal, 5)
//                .padding(.vertical, 5)
//                .background(showFullPlayer ? .clear : .gray.opacity(0.05))
//                .clipShape(RoundedRectangle(cornerRadius: 10))
//    
//                if showFullPlayer {
//                    FullPlayer()
//                }
//            }
//        }
}
import SwiftUI

struct PlayerContainerView: View {
    @EnvironmentObject var vm: PlayerViewModel

    var body: some View {
        VStack {
            if vm.isShowingFullPlayer {
                PlayerView(showHiddenButton: true)
                .transition(.move(edge: .bottom))
            } else {
                MiniPlayerView()
                    .transition(.move(edge: .bottom))
            }
        }
        .animation(.easeInOut, value: vm.isShowingFullPlayer)
    }
}

/// Вью для звукового представления.
struct PlayerView2: View {
    @EnvironmentObject var vm: PlayerViewModel
//    @State var showHiddenButton: Bool
//    @EnvironmentObject var viewModel: GetPracticesViewModel

//    @State var showFullPlayer = false
    
    @Binding var audio: Data?
    @Binding var image: UIImage?
    @Binding var title: String
    @Binding var therapeuticPurpose: String
    @Binding var frequency: String
    @Binding var practiceId: String

//    var isCompact: Bool = false
//    @State private var isLoadingAudio = false
//    @State private var audioLoadingError: String?
//    @Namespace private var playerAnimation
    var frameImage: CGFloat = 320
    
    var body: some View {
        FullPlayer()
            .onAppear {
                vm.getAudioInfo(
                    song: audio,
                    title: title,
                    image: image,
                    therapeuticPurpose: therapeuticPurpose,
                    frequency: frequency,
                    practiceId: practiceId
                )
            }
            .onChange(of: audio) { _, newAudio in
                vm.getAudioInfo(
                    song: newAudio,
                    title: title,
                    image: image,
                    therapeuticPurpose: therapeuticPurpose,
                    frequency: frequency,
                    practiceId: practiceId
                )
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
            SongImageView(image: vm.image)
            
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
        .onDisappear {
            vm.stopAudio()

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
            Text(vm.title.isEmpty ? "Title" : vm.title)
                .font(.system(size: 24, weight: .semibold))
                .multilineTextAlignment(.center)
            
            HStack(spacing: 8) {
                Text(vm.therapeuticPurpose.isEmpty ? "Therapeutic purpose" : "\(vm.therapeuticPurpose)")
                    .font(.system(size: 16, weight: .light))
                
                if vm.frequency != "" {
                    HStack(spacing: 4) {
                        Image(systemName: "waveform")
                            .font(.system(size: 14))
                        Text(vm.frequency)
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
                        .cornerRadius(0)
                        .padding(0)
//                        .cornerRadius(isCompact ? 16 : 0)
//                        .padding(isCompact ? 16 : 0)
                )
                .edgesIgnoringSafeArea(.all)
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
    
//        @ViewBuilder
//        private func MiniPlayer() -> some View {
//            VStack {
//                HStack {
//                    SongImageView(image: image, size: frameImage)
//
//                    if !showFullPlayer {
//                        VStack(alignment: .leading) {
//                            SongDescription()
//                        }
//                        .matchedGeometryEffect(id: "Description", in: playerAnimation)
//
//                        Spacer()
//
//                        CustomButton(image: vm.isPlaying ? "pause" : "play.fill", size: .headline) {
//                            vm.playPauseAudio()
//                        }
//                        .padding(.trailing)
//                    }
//                }
//                .padding(.horizontal, 5)
//                .padding(.vertical, 5)
//                .background(showFullPlayer ? .clear : .gray.opacity(0.05))
//                .clipShape(RoundedRectangle(cornerRadius: 10))
//
//                if showFullPlayer {
//                    FullPlayer()
//                }
//            }
//        }
}

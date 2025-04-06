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
    
    @Namespace private var playerAnimation
    
    var frameImage: CGFloat {
        showFullPlayer ? 320 : 60
    }
    
    var body: some View {
        MiniPlayer()
            .onAppear {
                vm.getAudioInfo(song: audio)
            }
            .onChange(of: audio) { _, newAudio in
                vm.getAudioInfo(song: newAudio)
            }
            .onTapGesture {
                withAnimation(.spring) {
                    self.showFullPlayer.toggle()
                }
            }
    }
    
    // MARK: - Methods
    @ViewBuilder
    private func MiniPlayer() -> some View {
        VStack {
            HStack {
                SongImageView(image: image, size: frameImage)

                if !showFullPlayer {
                    VStack(alignment: .leading) {
                        SongDescription()
                    }
                    .matchedGeometryEffect(id: "Description", in: playerAnimation)
                    
                    Spacer()
                    
                    CustomButton(image: vm.isPlaying ? "pause" : "play.fill", size: .headline) {
                        vm.playPauseAudio()
                    }
                    .padding(.trailing)
                }
            }
            .padding(.horizontal, 5)
            .padding(.vertical, 5)
            .background(showFullPlayer ? .clear : .gray.opacity(0.05))
            .clipShape(RoundedRectangle(cornerRadius: 10))

            if showFullPlayer {
                FullPlayer()
            }
        }
    }
    
    /// Расскрывающийся большой плейер
    @ViewBuilder
    private func FullPlayer() -> some View {
        /// Description
        VStack {
            SongDescription()
        }
        .matchedGeometryEffect(id: "Description", in: playerAnimation)
        .padding(.top)
        
        VStack {
            /// Duration
            HStack {
                Text("\(vm.formateDuration(duration: vm.currentTime))")
                    .font(customFont: .FuturaPTLight, size: 20)
                Spacer()
                Text("\(vm.formateDuration(duration: vm.totalTime))")
                    .font(customFont: .FuturaPTLight, size: 20)
            }
            
            /// Slider
            Slider(value: $vm.currentTime, in: 0...vm.totalTime) { editing in
                if (!editing) {
                    vm.seekAudio(time: vm.currentTime)
                }
            }
            .offset(y: -18)
            .tint(.blackAdaptive)
            .onAppear {
                Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                    vm.updateProgress()
                }
            }
            
            CustomButton(image: vm.isPlaying ? "pause" : "play.fill", size: .largeTitle) {
                vm.playPauseAudio()
            }
            .padding()
        }
        .padding(.horizontal, 20)
    }
    
    @ViewBuilder
    private func SongDescription() -> some View {
        Text(title == "" ? "Title" : title)
            .font(customFont: .MarcellusRegular, size: 20)
        
        Text("\(therapeuticPurpose == "" ? "therapeutic purpose" : therapeuticPurpose) \(frequency)")
            .font(customFont: .FuturaPTLight, size: 20)
    }
    
    @ViewBuilder
    private func SongImageView(image: UIImage?, size: CGFloat) -> some View {
        if let uiImage = image {
            Image(uiImage: uiImage)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: size, height: size)
                .clipShape(RoundedRectangle(cornerRadius: 10))
        } else {
            ZStack {
                Color.gray
                    .frame(width: size, height: size)
                Image(systemName: "music.note")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: size/4)
                    .foregroundStyle(Color.whiteAdaptive)
            }
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }
    
    private func CustomButton(image: String, size: Font, action: @escaping () -> ()) -> some View {
        Button {
            action()
        } label: {
            Image(systemName: image)
                .foregroundStyle(Color.blackAdaptive)
                .font(size)
        }
    }
}

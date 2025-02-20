//
//  MiniPlayerView.swift
//  SoundBathingApp
//
//  Created by Ирина Печик on 18.02.2025.
//

import SwiftUI

/// Ячейка для звукового представления.
struct MiniPlayerView: View {
    var song: PracticeSongModel
    @StateObject var vm = MiniPlayerViewModel()
    @State private var showFullPlayer = false
    @Namespace private var playerAnimation
    
    var frameImage: CGFloat {
        showFullPlayer ? 320 : 60
    }
    
    var body: some View {
        MiniPlayer()
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
                if let uiImage = song.image {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: frameImage, height: frameImage)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                } else {
                    ZStack {
                        Color.gray
                            .frame(width: frameImage, height: frameImage)
                        Image(systemName: "music.note")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 30)
                            .foregroundStyle(Color.whiteAdaptive)
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                if !showFullPlayer {
                    VStack(alignment: .leading) {
                        SongDescription()
                    }
                    .matchedGeometryEffect(id: "Description", in: playerAnimation)
                    
                    Spacer()
                    
                    CustomButton(image: vm.isPlaying ? "pause" : "play.fill", size: .headline) {
                        vm.playAudio(song: song.data)
                    }
                    .padding(.trailing)
                }
                
    //            Text(vm.formateDuration(duration: song.duration))
    //                .font(customFont: .FuturaPTLight, size: 20)
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
                Text("00:00")
                    .font(customFont: .FuturaPTLight, size: 20)
                Spacer()
                Text("03:27")
                    .font(customFont: .FuturaPTLight, size: 20)
            }
            
            /// Slider
            Divider()
            
            CustomButton(image: "play.fill", size: .largeTitle) {
                // action
            }
            .padding()
        }
        .padding(.horizontal, 20)
    }
    
    @ViewBuilder
    private func SongDescription() -> some View {
        Text(song.title == "" ? "Title" : song.title)
            .font(customFont: .MarcellusRegular, size: 20)
        
        Text("\(song.therapeuticPurpose == "" ? "therapeutic purpose" : song.therapeuticPurpose) \(song.frequency ?? "")")
            .font(customFont: .FuturaPTLight, size: 20)
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

#Preview {
    MiniPlayerView(song: PracticeSongModel(title: "", description: "", meditationType: .daily, therapeuticPurpose: "", data: Data(count: 3), duration: 3))
}

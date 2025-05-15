//
//  MiniPlayerView.swift
//  SoundBathingApp
//
//  Created by Ирина Печик on 08.05.2025.
//

import SwiftUI

struct MiniPlayerView: View {
    @EnvironmentObject var vm: PlayerViewModel
    @State private var showFullPlayer = false
    
    var body: some View {
        if vm.image != nil || !vm.title.isEmpty {
            HStack {
                if let image = vm.image {
                    Image(uiImage: image)
                        .resizable()
                        .frame(width: 50, height: 50)
                        .cornerRadius(8)
                }

                VStack(alignment: .leading) {
                    Text(vm.title)
                        .font(.headline)
                    Text(vm.therapeuticPurpose)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }

                Spacer()

                Button(action: {
                    vm.playPauseAudio()
                }) {
                    Image(systemName: vm.isPlaying ? "pause.fill" : "play.fill")
                        .font(.title2)
                        .foregroundStyle(.black)
                }
            }
            .padding()
            .background(.ultraThinMaterial)
            .cornerRadius(12)
            .onTapGesture {
                withAnimation(.easeInOut) {
                    vm.isShowingFullPlayer = true
                }
            }
        }
    }
}

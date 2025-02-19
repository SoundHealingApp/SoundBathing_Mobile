//
//  PracticeSongCell.swift
//  SoundBathingApp
//
//  Created by Ирина Печик on 18.02.2025.
//

import SwiftUI

/// Ячейка для звукового представления.
struct PracticeSongCell: View {
    var song: PracticeSongModel
    let durationFormated: (TimeInterval) -> String
    
    var body: some View {
        HStack {
            if let uiImage = song.image {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 60, height: 60)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            } else {
                ZStack {
                    Color.gray
                        .frame(width: 60, height: 60)
                    Image(systemName: "music.note")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 30)
                        .foregroundStyle(Color.whiteAdaptive)
                }
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            
            VStack(alignment: .leading) {
                Text(song.title ?? "")
                    .font(customFont: .MarcellusRegular, size: 20)
                Text("\(song.therapeuticPurpose ?? "") \(song.frequency ?? "")")
                    .font(customFont: .FuturaPTLight, size: 20)
            }
            
            Spacer()
            
            if let duration = song.duration {

                Text(durationFormated(duration))
                    .font(customFont: .FuturaPTLight, size: 20)
            }
        }
        .listRowBackground(Color.clear)
        .listRowSeparator(.hidden)
    }
}

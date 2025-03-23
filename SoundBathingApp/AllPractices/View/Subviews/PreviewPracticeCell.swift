//
//  PreviewCell.swift
//  SoundBathingApp
//
//  Created by Ирина Печик on 24.02.2025.
//

import SwiftUI

struct PreviewPracticeCell: View {
    let practice: Practice
    
    var body: some View {
        GeometryReader { geo in
            let size = geo.size
            
            ZStack(alignment: .bottom) {
                ZStack(alignment: .topTrailing) {
                    CardImageView(
                        image: practice.image,
                        width: size.width,
                        height: size.height)
                    
                    Button {
                        // action
                    } label: {
                        Image(systemName: "heart.fill")
                            .padding(10)
                            .foregroundStyle(practice.isFavorite ? .red : .white)
                            .background(.black)
                            .clipShape(Circle())
                            .padding()
                    }
                }
                
                VStack(alignment: .leading) {
                    Text(practice.title)
                        .font(customFont: .LoraRegular, size: 18)
                        .lineLimit(1)
                    Text(practice.therapeuticPurpose)
                        .font(customFont: .LoraRegular, size: 15)
                        .lineLimit(1)
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 3)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(.background.opacity(0.4))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(10)
            }
        }
        .frame(width: UIScreen.main.bounds.width * 0.45, height: UIScreen.main.bounds.width * 0.45)
    }
}

#Preview {
    PracticesView()

//    PreviewPracticeCell(
//        practice: Practice(
//            id: "id",
//            title: "title",
//            description: "dec",
//            meditationType: MeditationCategory.daily,
//            therapeuticPurpose: "ther",
//            image: UIImage(systemName: "swift")!,
////            audioLink: "link",
//            feedbacks: [],
//            isFavorite: false
//        )
//    )
}

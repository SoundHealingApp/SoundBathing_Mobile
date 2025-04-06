//
//  PreviewCell.swift
//  SoundBathingApp
//
//  Created by Ирина Печик on 24.02.2025.
//

import SwiftUI

struct PreviewPracticeCell: View {
    @StateObject var viewModel: GetPracticesViewModel
    let sizeCoefficient: Double
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
                    .clipShape(RoundedRectangle(cornerRadius: 20))

                    
                    Button {
                        Task {
                            await viewModel.toggleLike(practiceId: practice.id)
                        }
                    } label: {
                        Image(systemName: "heart.fill")
                            .padding(10)
                            .foregroundStyle(practice.isFavorite ? .red : .white)
                            .background(.black)
                            .clipShape(Circle())
                            .padding()
                    }
                }
                
                // Градиент для улучшения читаемости текста
                LinearGradient(
                    gradient: Gradient(colors: [Color.black.opacity(0.8), Color.black.opacity(0)]),
                    startPoint: .bottom,
                    endPoint: .top
                )
                .frame(height: size.height * 0.4)
                .clipShape(RoundedRectangle(cornerRadius: 15))
                
                VStack(alignment: .leading) {
                    Text(practice.title.uppercased())
                        .font(customFont: .GraphikMedium, size: 18)
                        .foregroundStyle(.white)
                        .lineLimit(3)
                    Text(practice.therapeuticPurpose)
                        .font(customFont: .GraphikRegular, size: 15)
                        .foregroundStyle(.white)
                        .lineLimit(2)
                }
                .padding(10)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .frame(width: UIScreen.main.bounds.width * sizeCoefficient, height: UIScreen.main.bounds.width * sizeCoefficient)
    }
}

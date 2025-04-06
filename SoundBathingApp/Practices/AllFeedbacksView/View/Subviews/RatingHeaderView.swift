//
//  RatingHeaderView.swift
//  SoundBathingApp
//
//  Created by Ирина Печик on 02.04.2025.
//

import SwiftUI

struct RatingHeaderView: View {
    let averageRating: Double
    let totalReviews: Int
    let ratingDistribution: [Int: Int]
    
    var body: some View {
        HStack(spacing: 16) {
            // Основной рейтинг
            VStack(alignment: .leading, spacing: 4) {
                Text(String(format: "%.1f", averageRating))
                    .font(.system(size: 32, weight: .bold))
                
                RatingStars(rating: averageRating, size: 14)
                
                Text("\(totalReviews) feedbacks")
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
            }
            .padding()
            
            // Распределение рейтингов
            VStack(alignment: .leading) {
                ForEach([5, 4, 3, 2, 1], id: \.self) { rating in
                    let count = ratingDistribution[rating] ?? 0
                    let percentage = totalReviews > 0 ? Double(count) / Double(totalReviews) * 100 : 0
                    
                    HStack(spacing: 8) {
                        HStack(spacing: 2) {
                            Text("\(rating)")
                                .font(.system(size: 12, weight: .medium))
                            Image(systemName: "star.fill")
                                .font(.system(size: 10))
                                .foregroundColor(.black)
                        }
                        .frame(width: 30, alignment: .trailing)
                        
                        // Полоска прогресса
                        GeometryReader { geometry in
                            ZStack(alignment: .leading) {
                                Rectangle()
                                    .fill(Color(.systemFill).opacity(0.5))
                                    .frame(height: 3)
                                    .cornerRadius(3)
                                
                                Rectangle()
                                    .fill(.black)
                                    .frame(width: geometry.size.width * CGFloat(percentage) / 100, height: 3)
                                    .cornerRadius(3)
                            }
                        }
                        .frame(height: 6)
                        
                        Text("\(Int(percentage))%")
                            .font(.system(size: 12, weight: .medium))
                        
                    }
                }
            }
            .frame(height: 120)
        }
        .padding(.horizontal, 16)
        .padding(.top, 20)
    }
}

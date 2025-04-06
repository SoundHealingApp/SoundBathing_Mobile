//
//  RatingStars.swift
//  SoundBathingApp
//
//  Created by Ирина Печик on 02.04.2025.
//

import SwiftUI

struct RatingStars: View {
    let rating: Double
    let size: CGFloat
    
    var body: some View {
        HStack(spacing: 2) {
            ForEach(1..<6, id: \.self) { star in
                Image(systemName: star <= Int(rating.rounded(.down)) ? "star.fill" :
                              (Double(star) - rating <= 0.5 ? "star.leadinghalf.filled" : "star"))
                    .foregroundColor(.orange)
                    .font(.system(size: size))
            }
        }
    }
}

#Preview {
    RatingStars(rating: 4.5, size: 14)
}

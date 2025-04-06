//
//  CellImageView.swift
//  SoundBathingApp
//
//  Created by Ирина Печик on 23.03.2025.
//

import SwiftUI

struct CardImageView: View {
    let image: UIImage
    let width: CGFloat
    let height: CGFloat
    
    var body: some View {
        Image(uiImage: image)
            .resizable()
            .scaledToFill()
            .frame(width: width, height: height)
    }
}

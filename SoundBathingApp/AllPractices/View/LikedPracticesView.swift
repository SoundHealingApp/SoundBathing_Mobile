//
//  LikedPractices.swift
//  SoundBathingApp
//
//  Created by Ирина Печик on 24.02.2025.
//

import SwiftUI

struct LikedPracticesView: View {
    @StateObject var viewModel: GetPracticesViewModel

    var columns = Array(repeating: GridItem(), count: 2)
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: false) {
                LazyVGrid(columns: columns) {
                    ForEach(Array(viewModel.likedPractices), id: \.id) { practice in
                        PreviewPracticeCell(practice: practice)
                    }
                }
            }
        }
        .navigationTitle("Favorites")
        .onAppear {
            Task {
                viewModel.getLikedPractices()
            }
        }
    }
}
//
//#Preview {
//    LikedPracticesView()
//}

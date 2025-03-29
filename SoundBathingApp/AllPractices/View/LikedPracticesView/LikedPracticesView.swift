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
        ScrollView(.vertical, showsIndicators: false) {
            LazyVGrid(columns: columns) {
                ForEach(Array(viewModel.likedPractices.filter { $0.isFavorite }), id: \.id) { practice in
                    NavigationLink(
                        destination: PracticesInfoView(practice: practice,getPracticesViewModel: viewModel)) {
                        PreviewPracticeCell(viewModel: viewModel, sizeCoefficient: 0.45, practice: practice)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .padding(.horizontal, 10)
        .navigationTitle("Favorites")
        .onAppear {
            Task {
                viewModel.getLikedPractices()
            }
        }
    }
}

//#Preview {
//    LikedPracticesView(viewModel: GetPracticesViewModel())
//}
#Preview {
    PracticesView()
}

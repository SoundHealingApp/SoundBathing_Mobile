//
//  PracticeView.swift
//  SoundBathingApp
//
//  Created by Ирина Печик on 24.02.2025.
//

import SwiftUI

struct PracticesView: View {
    @StateObject var viewModel = GetPracticesViewModel()
    
    let rows = [GridItem(.adaptive(minimum: 150))]
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 20) {
                    // TODO: Отображение ближайшего стрима
                    
                    /// Guided Daily Moments
                    if !viewModel.practices.filter({$0.meditationType == MeditationCategory.daily}).isEmpty {
                        
                        SectionHeader(title: MeditationCategory.daily.rawValue)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            LazyHGrid(rows: rows, spacing: 16) {
                                ForEach(viewModel.practices.filter { $0.meditationType == MeditationCategory.daily }, id: \.id) { practice in
                                    PreviewPracticeCell(viewModel: viewModel, practice: practice)
                                        .contentShape(Rectangle())
                                }
                                
                            }
                        }
                        .padding(.horizontal, 10)
                    }
                    
                    /// Restorative Sound Bath
                    if !viewModel.practices.filter({$0.meditationType == MeditationCategory.restorative}).isEmpty {
                        
                        SectionHeader(title: MeditationCategory.restorative.rawValue)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            LazyHGrid(rows: rows, spacing: 16) {
                                ForEach(viewModel.practices.filter { $0.meditationType == MeditationCategory.restorative }, id: \.id) { practice in
                                    PreviewPracticeCell(viewModel: viewModel, practice: practice)
                                        .contentShape(Rectangle())
                                }
                                
                            }
                        }
                        .padding(.horizontal, 10)
                    }
                }
                .padding()
            }
            .shadow(color: .black.opacity(0.2), radius: 8, x: 5, y: 8)
            .navigationTitle("Practices")
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    NavigationLink(destination: LikedPracticesView(viewModel: viewModel)) {
                        Image(systemName: "heart.fill")
                            .font(.title2)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .onAppear {
            Task {
                await viewModel.getAllPractices()
            }
        }
    }
}

#Preview {
    PracticesView()
}

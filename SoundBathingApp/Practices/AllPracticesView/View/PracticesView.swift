//
//  PracticeView.swift
//  SoundBathingApp
//
//  Created by Ирина Печик on 24.02.2025.
//

import SwiftUI

struct PracticesView: View {
    @EnvironmentObject var viewModel: GetPracticesViewModel
//    @StateObject var viewModel: GetPracticesViewModel

    let rows = [GridItem(.adaptive(minimum: 150))]
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 20) {
                // TODO: Отображение рекомендованных практик
//                LiveStreamAnnouncementView(stream:             LiveStream(
//                    id: "1",
//                    title: "Evening Sound Bath Meditation",
//                    description: "Join us for a 45-minute deep relaxation session with Tibetan singing bowls and gong vibrations to help you unwind before sleep.",
//                    therapeuticPurpose: "Sleep Improvement",
//                    startDateTime: Date().addingTimeInterval(3600 * 3),
//                    // Через 3 часа
//                    youTubeUrl: "https://www.youtube.com/watch?v=Affh1xGriY8&t=3s"
//                )
//)
                /// Guided Daily Moments
                if !viewModel.practices.filter({$0.meditationType == MeditationCategory.daily}).isEmpty {
                    
                    SectionHeader(title: MeditationCategory.daily.rawValue)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHGrid(rows: rows, spacing: 16) {
                            ForEach(viewModel.practices.filter { $0.meditationType == MeditationCategory.daily }, id: \.id) { practice in
                                NavigationLink(
                                    destination:
                                        PracticesInfoView(
                                            getPracticesViewModel: viewModel,
                                            practice: practice)
                                ) {
                                    PreviewPracticeCell(viewModel: viewModel, sizeCoefficient: 0.6, practice: practice)
                                        .contentShape(Rectangle())
                                }
                                .buttonStyle(.plain)
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
                                NavigationLink(
                                    destination: PracticesInfoView(
                                        getPracticesViewModel: viewModel,
                                        practice: practice)
                                ) {
                                    PreviewPracticeCell(viewModel: viewModel, sizeCoefficient: 0.6, practice: practice)
                                        .contentShape(Rectangle())
                                }
                                .buttonStyle(.plain)
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
        .refreshable {
            Task {
                await viewModel.getAllPractices()
            }
        }
    }
}

#Preview {
    PracticesView()
}

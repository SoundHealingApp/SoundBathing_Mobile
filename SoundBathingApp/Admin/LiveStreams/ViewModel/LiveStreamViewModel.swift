//
//  LiveStreamViewModel.swift
//  SoundBathingApp
//
//  Created by Ирина Печик on 12.04.2025.
//

import Foundation
// TODO: парсить дату в текущем часовом поисе
@MainActor
class LiveStreamViewModel: ObservableObject {
    @Published var liveStreams: [LiveStream] = []
    @Published var showingAddStream = false
    @Published var editingStream: LiveStream?

    func addStream(_ stream: LiveStream) {
        liveStreams.append(stream)
    }
    
    func updateStream(_ updatedStream: LiveStream) {
         if let index = liveStreams.firstIndex(where: { $0.id == updatedStream.id }) {
             liveStreams[index] = updatedStream
         }
     }
    
    func deleteStream(at offsets: IndexSet) {
        liveStreams.remove(atOffsets: offsets)
     }
     
    func deleteStream(_ stream: LiveStream) {
        liveStreams.removeAll { $0.id == stream.id }
     }
}

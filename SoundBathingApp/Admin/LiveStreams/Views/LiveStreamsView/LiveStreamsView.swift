//
//  LiveStreamsView.swift
//  SoundBathingApp
//
//  Created by Ирина Печик on 12.04.2025.
//

import SwiftUI

struct LiveStreamsView: View {
    @StateObject private var viewModel = LiveStreamViewModel()
    @State private var showDeleteConfirmation = false
    @State private var streamToDelete: LiveStream?
    @State private var scrollOffset: CGFloat = 0
    @State private var isLoading = true
    
    var body: some View {
        NavigationStack {
            ZStack {
                if isLoading {
                    // Показываем индикатор загрузки
                    ProgressView()
                        .scaleEffect(1.5)
                        .transition(.opacity)
                }
                 else if viewModel.liveStreams.isEmpty {
                        VStack(spacing: 24) {
                            /// Иконка камеры
                            ZStack {
                                Circle()
                                    .fill(
                                        LinearGradient(
                                            colors: [.purple.opacity(0.1), .indigo.opacity(0.1)],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .frame(width: 180, height: 180)
                                
                                Image(systemName: "video.fill")
                                    .font(.system(size: 60))
                                    .foregroundStyle(LinearGradient(
                                        colors: [.purple, .indigo],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    ))
                                    /// Анимация при отсутствии стримов
                                    .symbolEffect(.bounce, value: viewModel.liveStreams.isEmpty)
                            }
                            
                            /// Текст о том, что практики отсутсвуют
                            VStack(spacing: 12) {
                                Text("No Live Streams Yet")
                                    .font(.system(.title2, design: .rounded).bold())
                                    .foregroundColor(.primary)
                                
                                Text("Add your first live stream to get started")
                                    .font(.system(.subheadline, design: .rounded))
                                    .foregroundColor(.secondary)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 40)
                            }
                            
                            Button {
                                viewModel.showingAddStream = true
                            } label: {
                                HStack {
                                    Image(systemName: "plus")
                                    Text("Add Stream")
                                }
                                .font(.system(.headline, design: .rounded))
                                .padding(.horizontal, 32)
                                .padding(.vertical, 14)
                                .background(
                                    Capsule()
                                        .fill(LinearGradient(
                                            colors: [.purple, .indigo],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        ))
                                        .shadow(color: .purple.opacity(0.3), radius: 10, y: 5)
                                )
                                .foregroundColor(.white)
                            }
                            .buttonStyle(ScaleButtonStyle())
                        }
                        .padding()
                        /// Плавное появление/исчезновение
                        .transition(.scale.combined(with: .opacity))
                    } else {
                        ScrollView {
                            GeometryReader { proxy in
                                Color.clear
                                    .preference(key: ScrollOffsetKey.self, value: proxy.frame(in: .named("scroll")).minY)
                            }
                            .frame(height: 0)
                            
                            LazyVStack(spacing: 20) {
                                ForEach(viewModel.liveStreams) { stream in
                                    LiveStreamCardView(stream: stream)
                                        .rotation3DEffect(
                                            .degrees(scrollOffset * 0.05),
                                            axis: (x: 1, y: 0, z: 0),
                                            perspective: 0.5
                                        )
                                        .contextMenu {
                                            Button {
                                                viewModel.editingStream = stream
                                            } label: {
                                                Label("Edit", systemImage: "pencil")
                                            }
                                            
                                            Button(role: .destructive) {
                                                streamToDelete = stream
                                                showDeleteConfirmation = true
                                            } label: {
                                                Label("Delete", systemImage: "trash")
                                            }
                                        }
                                        .transition(
                                            .asymmetric(
                                                insertion: .move(edge: .leading).combined(with: .opacity),
                                                removal: .move(edge: .trailing).combined(with: .opacity)
                                            )
                                        )
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.top, 20)
                            .padding(.bottom, 40)
                        }
                        .coordinateSpace(name: "scroll")
                        .onPreferenceChange(ScrollOffsetKey.self) { value in
                            withAnimation(.linear(duration: 0.1)) {
                                scrollOffset = value
                            }
                        }
                    }
            }
            .navigationTitle("Live Streams")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        viewModel.showingAddStream = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .symbolRenderingMode(.hierarchical)
                            .foregroundStyle(LinearGradient(
                                colors: [.purple, .indigo],
                                startPoint: .leading,
                                endPoint: .trailing
                            ))
                            .symbolEffect(.bounce, value: viewModel.showingAddStream)
                    }
                }
            }
            .onAppear {
                Task {
                    isLoading = true /// Показываем индикатор загрузки
                    await viewModel.getUpcomingStreams()
                    isLoading = false /// Скрываем индикатор после загрузки
                }
            }
            .sheet(isPresented: $viewModel.showingAddStream) {
                LiveStreamCreationView()
                    .environmentObject(viewModel)
            }
            .sheet(item: $viewModel.editingStream) { stream in
                LiveStreamCreationView(stream: stream)
                    .environmentObject(viewModel)
            }
            .alert("Delete Stream?", isPresented: $showDeleteConfirmation, presenting: streamToDelete) { stream in
                Button("Delete", role: .destructive) {
                    Task {
                        await viewModel.deleteStream(id: stream.id)
                    }
                }
                Button("Cancel", role: .cancel) {}
            } message: { _ in
                Text("This stream will be permanently deleted.")
            }
        }
    }
}

// MARK: - Helper Views and Extensions
private struct ScrollOffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value += nextValue()
    }
}

#Preview {
    LiveStreamsView()
}

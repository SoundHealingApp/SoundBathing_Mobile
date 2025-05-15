//
//  QuotesView.swift
//  SoundBathingApp
//
//  Created by Ирина Печик on 08.04.2025.
//

import SwiftUI

struct QuotesView: View {
    @StateObject private var viewModel = QuotesViewModel()
    @State private var showDeleteConfirmation = false
    @State private var quoteToDelete: Quote?
    @State private var scrollOffset: CGFloat = 0
    
    var body: some View {
        ZStack {
            if viewModel.quotes.isEmpty {
                /// Информация об отсутствии практик.
                VStack(spacing: 24) {
                    ZStack {
                        Circle()
                            .fill(LinearGradient(
                                colors: [.purple.opacity(0.1), .indigo.opacity(0.1)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ))
                            .frame(width: 180, height: 180)
                        
                        Image(systemName: "quote.bubble.fill")
                            .font(.system(size: 60))
                            .foregroundStyle(LinearGradient(
                                colors: [.purple, .indigo],
                                startPoint: .leading,
                                endPoint: .trailing
                            ))
                            .symbolEffect(.bounce, value: viewModel.quotes.isEmpty)
                    }
                    
                    VStack(spacing: 12) {
                        Text("No Quotes Yet")
                            .font(.system(.title2, design: .rounded).bold())
                            .foregroundColor(.primary)
                        
                        Text("Add your first inspirational quote to get started")
                            .font(.system(.subheadline, design: .rounded))
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                    }
                    
                    Button(action: { viewModel.showingAddQuote = true }) {
                        HStack {
                            Image(systemName: "plus")
                            Text("Add Quote")
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
                .transition(.scale.combined(with: .opacity))
            } else {
                /// Параллакс-эффект
                ScrollView {
                    GeometryReader { proxy in
                        Color.clear
                            .preference(key: ScrollOffsetKey.self, value: proxy.frame(in: .named("scroll")).minY)
                    }
                    .frame(height: 0)
                    
                    LazyVStack(spacing: 20) {
                        ForEach(viewModel.quotes) { quote in
                            QuoteCardView(quote: quote)
                                .rotation3DEffect(
                                    .degrees(scrollOffset * 0.05),
                                    axis: (x: 1, y: 0, z: 0),
                                    perspective: 0.5
                                )
                                .contextMenu {
                                    Button {
                                        viewModel.editingQuote = quote
                                    } label: {
                                        Label("Edit", systemImage: "pencil")
                                    }
                                    
                                    Button(role: .destructive) {
                                        quoteToDelete = quote
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
                    
                    Spacer()
                        .frame(height: 100) // Высота таб-бара + дополнительный отступ
                }
                .coordinateSpace(name: "scroll")
                .onPreferenceChange(ScrollOffsetKey.self) { value in
                    withAnimation(.linear(duration: 0.1)) {
                        scrollOffset = value
                    }
                }
            }
        }
        .navigationTitle("Quotes")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    viewModel.showingAddQuote = true
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                        .symbolRenderingMode(.hierarchical)
                        .foregroundStyle(LinearGradient(
                            colors: [.purple, .indigo],
                            startPoint: .leading,
                            endPoint: .trailing
                        ))
                        .symbolEffect(.bounce, value: viewModel.showingAddQuote)
                }
            }
        }
        .onAppear {
            Task {
                await viewModel.getAllQuotes()
            }
        }
        .sheet(isPresented: $viewModel.showingAddQuote) {
            QuoteCreationView()
                .environmentObject(viewModel)
        }
        .sheet(item: $viewModel.editingQuote) { quote in
            QuoteCreationView(quote: quote)
                .environmentObject(viewModel)
        }
        .alert("Delete Quote?", isPresented: $showDeleteConfirmation, presenting: quoteToDelete) { quote in
            Button("Delete", role: .destructive) {
                Task {
                    await viewModel.deleteQuote(id: quote.id)
                }
            }
            Button("Cancel", role: .cancel) {}
        } message: { _ in
            Text("This quote will be permanently deleted.")
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
    QuotesView()
}

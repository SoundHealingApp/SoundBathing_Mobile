//
//  LiveStreamDetailView.swift
//  SoundBathingApp
//
//  Created by Ирина Печик on 13.04.2025.
//

import SwiftUI
import EventKit

struct LiveStreamDetailView: View {
    let stream: LiveStream
    @State private var isTimerPulsing = false

    @Environment(\.dismiss) var dismiss
    @State private var showReminderAdded = false
    @State private var showShareSheet = false
    @State private var showReminderError = false
    @Environment(\.openURL) var openURL

    private let eventStore = EKEventStore()
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            /// Фон
            Color(.systemGroupedBackground)
                .ignoresSafeArea()
            
            /// Основной контент
            ScrollView {
                VStack(spacing: 0) {
                    // Общая карточка (контейнер)
                    VStack(spacing: 0) {
                        /// Видеоплеер с закругленными углами только сверху
                        YouTubePlayerView(videoID: ExtractYouTubeIDHelper.extractYouTubeID(from: stream.youTubeUrl) ?? "")
                            .frame(height: 220)
                            .frame(maxWidth: .infinity)
                            .clipShape(
                                UnevenRoundedRectangle(
                                    cornerRadii: .init(
                                        topLeading: 16,
                                        bottomLeading: 0,
                                        bottomTrailing: 0,
                                        topTrailing: 16
                                    )
                                )
                            )
                            .overlay(
                                UnevenRoundedRectangle(
                                    cornerRadii: .init(
                                        topLeading: 16,
                                        bottomLeading: 0,
                                        bottomTrailing: 0,
                                        topTrailing: 16
                                    )
                                )
                                .stroke(Color(.systemGray5), lineWidth: 1)
                            )
                        
                        /// Информация о стриме
                        VStack(alignment: .leading, spacing: 12) {
                            
                            /// Заголовок и дата
                            VStack(alignment: .leading, spacing: 8) {
                                Text(stream.title)
                                    .font(.system(.title2, design: .rounded, weight: .bold))

                                    .foregroundColor(.primary)
                                
                                HStack(spacing: 12) {
                                    if !stream.therapeuticPurpose.isEmpty {
                                        Text(stream.therapeuticPurpose)
                                            .font(.system(.caption, design: .rounded, weight: .regular))
                                            .foregroundColor(.white)
                                            .padding(.vertical, 6)
                                            .padding(.horizontal, 10)
                                            .background(
                                                Capsule().fill(
                                                    LinearGradient(
                                                        gradient: Gradient(colors: [.indigo, .purple]),
                                                        startPoint: .leading,
                                                        endPoint: .trailing
                                                    )
                                                )
                                            )
                                    }
                                    
                                    // Анимированный таймер
                                    Label(timeRemaining, systemImage: "clock.badge")
                                        .font(.system(.caption, design: .rounded, weight: .regular))
                                        .foregroundColor(.white)
                                        .padding(.vertical, 6)
                                        .padding(.horizontal, 10)
                                        .background(
                                            Capsule().fill(
                                                LinearGradient(
                                                    gradient: Gradient(colors: [.orange, .red]),
                                                    startPoint: .leading,
                                                    endPoint: .trailing
                                                )
                                            )
                                        )
                                        .scaleEffect(isTimerPulsing ? 1.05 : 1.0)
                                        .animation(.easeInOut(duration: 1.0).repeatForever(), value: isTimerPulsing)
                                }
                                .onAppear { isTimerPulsing = true }
                                
                                // Дата и время
                                HStack(spacing: 8) {
                                    Image(systemName: "calendar")
                                        .foregroundColor(.secondary)
                                    Text(stream.startDateTime.formatted(date: .abbreviated, time: .shortened))
                                        .font(.system(.subheadline, design: .rounded))
                                        .foregroundColor(.secondary)
                                }
                            }
                            
   
                            
                            // Описание
                            Text(stream.description)
                                .font(.system(.body, design: .rounded))
                                .foregroundColor(.primary)
                                .padding(.vertical, 8)
                            
                            Spacer()
                            // Кнопки
                            // Кнопки действий
                            HStack(spacing: 12) {
                                if stream.startDateTime > Date() {
                                    Button(action: addReminder) {
                                        HStack {
                                            Image(systemName: "bell.badge.fill")
                                                .symbolRenderingMode(.multicolor)
                                            Text("Reminder")
                                        }
                                        .frame(maxWidth: .infinity)
                                        .padding(12)
                                        .background(Color.indigo.opacity(0.1))
                                        .foregroundColor(.indigo)
                                        .cornerRadius(12)
                                    }
                                }
                                
                                Button(action: { showShareSheet = true }) {
                                    HStack {
                                        Image(systemName: "square.and.arrow.up")
                                        Text("Share")
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding(12)
                                    .background(Color.gray.opacity(0.1))
                                    .foregroundColor(.primary)
                                    .cornerRadius(12)
                                }
                            }
                            .buttonStyle(.plain)
                        }
                        .padding(20)
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color(.systemBackground))
                            .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
                    )
                    .padding(.horizontal, 16)
                    .padding(.top, 24)
                    .padding(.bottom, 40)
                }
            }
            
            // Кнопка закрытия
            Button(action: { dismiss() }) {
                Image(systemName: "xmark.circle.fill")
                    .font(.title2)
                    .symbolRenderingMode(.hierarchical)
                    .foregroundColor(.secondary)
                    .background(Circle().fill(Color(.systemBackground)))
                    .padding(16)
            }
            
            // Уведомления
            if showReminderAdded {
                ReminderAddedConfirmation()
                    .transition(.move(edge: .top).combined(with: .opacity))
            }
            
            if showReminderError {
                ReminderErrorConfirmation()
                    .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
        .sheet(isPresented: $showShareSheet) {
            ActivityView(activityItems: [stream.shareMessage])
        }
    }
    
    private var timeRemaining: String {
        let components = Calendar.current.dateComponents(
            [
                .day,
                .hour,
                .minute
            ],
            from: Date(),
            to: stream.startDateTime
        )
        
        var parts = [String]()
        if let days = components.day, days > 0 { parts.append("\(days)d") }
        if let hours = components.hour, hours > 0 { parts.append("\(hours)h") }
        if let minutes = components.minute, minutes > 0 { parts.append("\(minutes)m") }
        
        return parts.isEmpty ? "Starting soon" : parts.joined(separator: " ")
    }

    private func addReminder() {
        eventStore.requestFullAccessToEvents { granted, error in
            DispatchQueue.main.async {
                if granted, error == nil {
                    let event = EKEvent(eventStore: eventStore)
                    event.title = stream.title
                    event.startDate = stream.startDateTime
                    event.endDate = stream.startDateTime.addingTimeInterval(3600)
                    event.notes = stream.description
                    event.calendar = eventStore.defaultCalendarForNewEvents

                    do {
                        try eventStore.save(event, span: .thisEvent)
                        withAnimation {
                            showReminderAdded = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                withAnimation {
                                    showReminderAdded = false
                                }
                            }
                        }
                    } catch {
                        handleReminderError()
                    }
                } else {
                    handleReminderError()
                }
            }
        }
    }

    private func handleReminderError() {
        showReminderError = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation {
                showReminderError = false
            }
        }
    }

//    private func addReminder() {
//        eventStore.requestAccess(to: .event) { granted, error in
//            DispatchQueue.main.async {
//                if granted, error == nil {
//                    let event = EKEvent(eventStore: eventStore)
//                    event.title = stream.title
//                    event.startDate = stream.startDateTime
//                    event.endDate = stream.startDateTime.addingTimeInterval(3600)
//                    event.notes = stream.description
//                    event.calendar = eventStore.defaultCalendarForNewEvents
//                    
//                    do {
//                        try eventStore.save(event, span: .thisEvent)
//                        withAnimation {
//                            showReminderAdded = true
//                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//                                withAnimation {
//                                    showReminderAdded = false
//                                }
//                            }
//                        }
//                    } catch {
//                        showReminderError = true
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//                            withAnimation {
//                                showReminderError = false
//                            }
//                        }
//                    }
//                } else {
//                    showReminderError = true
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//                        withAnimation {
//                            showReminderError = false
//                        }
//                    }
//                }
//            }
//        }
//    }
}

// Helper Views (same as before)
struct ReminderAddedConfirmation: View {
    var body: some View {
        HStack {
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(.green)
            Text("Reminder Added")
                .font(.subheadline)
        }
        .padding()
        .background(Color(.tertiarySystemBackground))
        .cornerRadius(8)
        .shadow(radius: 2)
        .padding(.top, 44)
    }
}

struct ReminderErrorConfirmation: View {
    var body: some View {
        HStack {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundColor(.red)
            Text("Enable Calendar Access")
                .font(.subheadline)
        }
        .padding()
        .background(Color(.tertiarySystemBackground))
        .cornerRadius(8)
        .shadow(radius: 2)
        .padding(.top, 44)
    }
}

#Preview {
    LiveStreamDetailView(stream: LiveStream(
        id: "1",
        title: "Evening Sound Bath Meditation",
        description: "Join us for a 45-minute deep relaxation session with Tibetan singing bowls and gong vibrations to help you unwind before sleep. This session is specially designed to calm the mind and prepare your body for restful sleep.",
        therapeuticPurpose: "Sleep Improvement",
        startDateTime: Date().addingTimeInterval(3600 * 3),
        youTubeUrl: "https://www.youtube.com/watch?v=Xc4D2uIdWc0"
    ))
}
extension LiveStream {
    var shareMessage: String {
        """
        Join the Sound Wellness live stream!
        
        \(title)
        
        \(description)
        
        Starts: \(startDateTime.formatted(date: .long, time: .shortened))
        
        Watch here: \(youTubeUrl)
        
        #SoundWellness #SoundBathing
        """
    }
}


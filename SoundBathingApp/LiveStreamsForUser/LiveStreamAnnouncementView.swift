//
//  LiveStreamAnnouncementView.swift
//  SoundBathingApp
//
//  Created by Ирина Печик on 12.04.2025.
//

import SwiftUI
import EventKit

struct LiveStreamAnnouncementView: View {
    let stream: LiveStream
    @State private var showFullScreen = false
    @State private var isPressed = false

    private var formattedDate: String {
        if Calendar.current.isDateInToday(stream.startDateTime) {
            return "Today at " + stream.startDateTime.formatted(.dateTime.hour().minute())
        } else if Calendar.current.isDateInTomorrow(stream.startDateTime) {
            return "Tomorrow at " + stream.startDateTime.formatted(.dateTime.hour().minute())
        } else {
            return stream.startDateTime.formatted(.dateTime.weekday(.wide).day().month(.wide))
        }
    }

    var body: some View {
        Button(action: { showFullScreen = true }) {
            HStack(spacing: 12) {
                // Stream icon
                ZStack {
                    Circle()
                        .fill(LinearGradient(colors: [.indigo, .purple], startPoint: .topLeading, endPoint: .bottomTrailing))
                        .frame(width: 48, height: 48)
                        .shadow(color: .purple.opacity(0.2), radius: 6, x: 0, y: 3)

                    Image(systemName: "video.fill") // Изменена иконка на видеокамеру
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.white)
                        .rotationEffect(.degrees(isPressed ? 10 : 0)) // Добавлена анимация поворота
                        .animation(.easeInOut(duration: 0.2), value: isPressed)
                }

                // Stream info
                VStack(alignment: .leading, spacing: 4) {

                    // Title
                    Text(stream.title)
                        .font(.system(.headline, design: .rounded).bold())
                        .foregroundColor(.primary)
                        .lineLimit(2)

                    // Date
                    Text(formattedDate)
                        .font(.system(.caption, design: .rounded))
                        .foregroundColor(.secondary)

                    // Therapeutic Purpose
                    if !stream.therapeuticPurpose.isEmpty {
                        Text(stream.therapeuticPurpose)
                            .font(.caption2.weight(.medium))
                            .foregroundColor(.indigo)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.indigo.opacity(0.08))
                            .clipShape(Capsule())
                    }
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.gray.opacity(0.5))
            }
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(.systemBackground))
                    .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 4)
            )
            .scaleEffect(isPressed ? 0.96 : 1)
            .animation(.easeOut(duration: 0.2), value: isPressed)
        }
        .buttonStyle(PlainButtonStyle())
        .pressAction {
            isPressed = true
        } onRelease: {
            isPressed = false
        }
        .fullScreenCover(isPresented: $showFullScreen) {
            StreamDetailView(stream: stream)
        }
    }
}

//// MARK: - Press Animation Modifier
extension View {
    func pressAction(onPress: @escaping (() -> Void), onRelease: @escaping (() -> Void)) -> some View {
        modifier(PressActions(onPress: { onPress() }, onRelease: { onRelease() }))
    }
}

struct PressActions: ViewModifier {
    var onPress: () -> Void
    var onRelease: () -> Void

    func body(content: Content) -> some View {
        content
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onChanged({ _ in onPress() })
                    .onEnded({ _ in onRelease() })
            )
    }
}


// MARK: - Press Animation Modifier
struct StreamDetailView: View {
    let stream: LiveStream
    @Environment(\.dismiss) var dismiss
    @State private var showReminderAdded = false
    @State private var showShareSheet = false
    @State private var showReminderError = false
    
    private let eventStore = EKEventStore()
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            // Background
            Color(.systemBackground)
                .ignoresSafeArea()
            
            // Content
            ScrollView {
                VStack(spacing: 0) {
                    // Video Player (same as card)
                    YouTubePlayerView(videoID: ExtractYouTubeIDHelper.extractYouTubeID(from: stream.youTubeUrl) ?? "")
                        .frame(height: 220)
                        .cornerRadius(12)
                        .padding(.horizontal)
                        .padding(.top, 24)
                    
                    // Stream Info (card-style layout)
                    VStack(alignment: .leading, spacing: 12) {
                        // Title
                        Text(stream.title)
                            .font(.system(.title2, design: .rounded).bold())
                            .foregroundColor(.primary)
                            .padding(.top, 8)
                        
                        // Date and Time
                        HStack(spacing: 16) {
                            Label(stream.startDateTime.formatted(date: .abbreviated, time: .shortened),
                                  systemImage: "calendar")
                            
                            if stream.startDateTime > Date() {
                                Label(timeRemaining, systemImage: "clock")
                            }
                        }
                        .font(.system(.subheadline, design: .rounded))
                        .foregroundColor(.secondary)
                        
                        // Therapeutic Purpose
                        if !stream.therapeuticPurpose.isEmpty {
                            Text(stream.therapeuticPurpose)
                                .font(.system(.caption, design: .rounded).bold())
                                .foregroundColor(.indigo)
                                .padding(.vertical, 6)
                                .padding(.horizontal, 10)
                                .background(Color.indigo.opacity(0.1))
                                .cornerRadius(6)
                        }
                        
                        // Description
                        Text(stream.description)
                            .font(.system(.body, design: .rounded))
                            .foregroundColor(.primary)
                            .padding(.top, 8)
                        
                        // Action Buttons
                        VStack(spacing: 12) {
                            if stream.startDateTime > Date() {
                                Button(action: addReminder) {
                                    HStack {
                                        Image(systemName: "bell.fill")
                                        Text("Set Reminder")
                                        Spacer()
                                        Text(timeRemaining)
                                    }
                                    .padding()
                                    .background(Color(.tertiarySystemBackground))
                                    .foregroundColor(.primary)
                                    .cornerRadius(12)
                                }
                            }
                            
                            Button(action: { showShareSheet = true }) {
                                HStack {
                                    Image(systemName: "square.and.arrow.up")
                                    Text("Share Stream")
                                    Spacer()
                                }
                                .padding()
                                .background(Color(.tertiarySystemBackground))
                                .foregroundColor(.primary)
                                .cornerRadius(12)
                            }
                        }
                        .padding(.top, 16)
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color(.tertiarySystemBackground))
                            .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 5)
                    )
                    .padding(.horizontal)
                    .padding(.bottom, 40)
                }
            }
            
            // Close Button
            Button(action: { dismiss() }) {
                Image(systemName: "xmark.circle.fill")
                    .font(.title2)
                    .symbolRenderingMode(.hierarchical)
                    .foregroundColor(.gray)
                    .padding(16)
            }
            
            // Notifications
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
        let components = Calendar.current.dateComponents([.day, .hour, .minute],
                                                       from: Date(),
                                                       to: stream.startDateTime)
        
        var parts = [String]()
        if let days = components.day, days > 0 { parts.append("\(days)d") }
        if let hours = components.hour, hours > 0 { parts.append("\(hours)h") }
        if let minutes = components.minute, minutes > 0 { parts.append("\(minutes)m") }
        
        return parts.isEmpty ? "Starting soon" : parts.joined(separator: " ")
    }
    
    private func addReminder() {
        eventStore.requestAccess(to: .event) { granted, error in
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
                        showReminderError = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation {
                                showReminderError = false
                            }
                        }
                    }
                } else {
                    showReminderError = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        withAnimation {
                            showReminderError = false
                        }
                    }
                }
            }
        }
    }
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



#Preview {
    LiveStreamAnnouncementView(
        stream:
            LiveStream(
                id: "1",
                title: "Evening Sound Bath Meditation",
                description: "Join us for a 45-minute deep relaxation session with Tibetan singing bowls and gong vibrations to help you unwind before sleep.",
                therapeuticPurpose: "Sleep Improvement",
                startDateTime: Date().addingTimeInterval(3600 * 3),
                // Через 3 часа
                youTubeUrl: "https://www.youtube.com/watch?v=Xc4D2uIdWc0"
            )
    )
}

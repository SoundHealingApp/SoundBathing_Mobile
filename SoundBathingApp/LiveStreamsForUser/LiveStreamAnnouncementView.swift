//
//  LiveStreamAnnouncementView.swift
//  SoundBathingApp
//
//  Created by Ирина Печик on 12.04.2025.
//

import SwiftUI

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
                    // Pulsing aura
                    Circle()
                        .fill(.indigo.opacity(0.1))
                        .frame(width: 64, height: 64)
                        .scaleEffect(isPressed ? 1.1 : 1.0)
                        .animation(.easeInOut(duration: 1.2).repeatForever(), value: isPressed)

                    // Gradient icon background
                    Circle()
                        .fill(
                            LinearGradient(colors: [.indigo, .purple], startPoint: .topLeading, endPoint: .bottomTrailing)
                        )
                        .frame(width: 48, height: 48)
                        .shadow(color: .purple.opacity(0.2), radius: 6, x: 0, y: 3)

                    // Icon
                    Image(systemName: "waveform")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.white)
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
//            .background(
//                RoundedRectangle(cornerRadius: 16)
//                    .fill(Color(.systemBackground))
////                    .shadow(color: Color.indigo.opacity(0.006), radius: 4, x: 0, y: 2)
//            )
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
            LiveStreamDetailView(stream: stream)
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

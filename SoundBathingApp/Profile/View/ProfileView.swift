//
//  ProfileView.swift
//  SoundBathingApp
//
//  Created by Ирина Печик on 06.04.2025.
//

import SwiftUI

// 1) Выйти из профиля
// 2) Сменить язык
struct ProfileView: View {
    @State private var selectedSection: ProfileSection? = nil
    @StateObject private var quotesViewModel = QuotesViewModel()
    @EnvironmentObject var userPermissionsVM: UserPermissionsViewModel
    @EnvironmentObject var appVM: AppViewModel
    @EnvironmentObject var signInVM: SignInViewModel
    @State private var canManagePractices = false
    @State private var canManageQuotes = false
    @State private var canManageLiveStreams = false
    @State private var showingLogoutAlert = false
    @State private var showingDeleteAccountAlert = false
    @State private var randomQuote: Quote = Quote(
        id: UUID().uuidString,
        author: "Anonymous",
        text: "Don’t compare someone’s middle to your beginning."
    )

    enum ProfileSection {
        case quotes
        case liveStreams
        case practices
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                UserPersonInformationCard()
                    .padding(.bottom, 8)
                
                dailyQuoteCard
                adminFunctionsSection
                accountManagementSection
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
        .navigationDestination(item: $selectedSection) { section in
            switch section {
            case .quotes:
                QuotesView()
            case .liveStreams:
                LiveStreamsView()
            case .practices:
                CreateMeditationView()
            }
        }
        .task {
            canManagePractices = await userPermissionsVM.CanCurrentUserManagePracticesAsync()
            canManageQuotes = await userPermissionsVM.CanCurrentUserManageQuotesAsync()
            canManageLiveStreams = await userPermissionsVM.CanCurrentUserManageLiveStreamsAsync()
        }
    }
    
    // MARK: - Секции для разных типов пользователей
    private var adminFunctionsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            if canManageQuotes || canManagePractices || canManageLiveStreams {
                Text("Admin Tools")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.black)
            }
            
            VStack(spacing: 12) {
                if canManageQuotes {
                    NavigationButton(title: "Manage Quotes", icon: "quote.bubble.fill", color: .purple) {
                        selectedSection = .quotes
                    }
                }
                
                if canManageLiveStreams {
                    NavigationButton(title: "Live Streams", icon: "video.fill", color: .red) {
                        selectedSection = .liveStreams
                    }
                }
                
                if canManagePractices {
                    NavigationButton(title: "Manage Practices", icon: "leaf.fill", color: .green) {
                        selectedSection = .practices
                    }
                }
            }
        }
    }
    
    // MARK: - Account Management Section
        private var accountManagementSection: some View {
            VStack(alignment: .leading, spacing: 16) {
                Text("Account Management")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.black)
                
                VStack(spacing: 12) {
                    // Logout Button
                    ActionButton(
                        title: "Sign Out",
                        icon: "rectangle.portrait.and.arrow.right",
                        color: .blue,
                        action: {
                            showingLogoutAlert = true
                        }
                    )
                    .alert(isPresented: $showingLogoutAlert) {
                        Alert(
                            title: Text("Confirm Sign Out"),
                            message: Text("Are you sure you want to sign out?"),
                            primaryButton: .destructive(Text("Sign Out")) {
                                appVM.signOut()
                            },
                            secondaryButton: .cancel()
                        )
                    }
                    
                    // Delete Account Button
                    ActionButton(
                        title: "Delete Account",
                        icon: "trash.fill",
                        color: .red,
                        action: {
                            showingDeleteAccountAlert = true
                        }
                    )
                    .alert(isPresented: $showingDeleteAccountAlert) {
                        Alert(
                            title: Text("Delete Account Permanently"),
                            message: Text("This action cannot be undone. All your data will be erased."),
                            primaryButton: .destructive(Text("Delete")) {
                                Task {
                                    await                             signInVM.sendDeleteAccountRequest(id: KeyChainManager.shared.getUserId() ?? "")
                                    
                                    appVM.deleteAccountAndResetApp()
                                }
                                                            },
                            secondaryButton: .cancel()
                        )
                    }
                }
            }
        }
    
    // MARK: - Дополнительные элементы
    private var dailyQuoteCard: some View {
        VStack(alignment: .leading) {
            Text("TODAY'S WISDOM")
                .font(.system(size: 12, weight: .semibold))
                .kerning(1.5)
                .foregroundColor(.gray)
            
            QuoteCardView(quote: randomQuote)
        }
        .onAppear {
            Task {
                randomQuote = await quotesViewModel.getDailyRandomQuote() ?? Quote(
                    id: UUID().uuidString,
                    author: "Anonymous",
                    text: "Don’t compare someone’s middle to your beginning."
                )
            }
        }
    }
}

// MARK: - Вспомогательные компоненты
struct NavigationButton: View {
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 18))
                    .foregroundColor(color)
                    .frame(width: 24)
                
                Text(title)
                    .font(.system(size: 18, weight: .medium))
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray.opacity(0.5))
            }
            .padding()
            .background(Color(.secondarySystemBackground))
            .cornerRadius(12)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Action Button Component
struct ActionButton: View {
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 18))
                    .foregroundColor(color)
                    .frame(width: 24)
                
                Text(title)
                    .font(.system(size: 18, weight: .medium))
                
                Spacer()
            }
            .padding()
            .background(Color(.secondarySystemBackground))
            .cornerRadius(12)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    ProfileView()
}

// MARK: - Later
//struct StatCard: View {
//    let value: String
//    let label: String
//    let icon: String
//    let color: Color
//
//    var body: some View {
//        VStack(spacing: 6) {
//            Image(systemName: icon)
//                .font(.system(size: 20))
//                .foregroundColor(color)
//
//            Text(value)
//                .font(.system(size: 18, weight: .bold))
//
//            Text(label)
//                .font(.system(size: 12))
//                .foregroundColor(.secondary)
//        }
//        .frame(maxWidth: .infinity)
//        .padding(12)
//        .background(Color(.secondarySystemBackground))
//        .cornerRadius(12)
//    }
//}
//
//    private var meditationStatsSection: some View {
//        VStack(alignment: .leading, spacing: 16) {
//            Text("Your Meditation Journey")
//                .font(.system(size: 20, weight: .semibold))
//
//            HStack(spacing: 16) {
//                StatCard(value: "27", label: "Sessions", icon: "brain.head.profile", color: .indigo)
//                StatCard(value: "5h 42m", label: "Total Time", icon: "clock.fill", color: .teal)
//                StatCard(value: "14", label: "Streak", icon: "flame.fill", color: .orange)
//            }
//        }
//    }

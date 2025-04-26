//
//  CreatePracticeView.swift
//  SoundBathingApp
//
//  Created by Ирина Печик on 17.02.2025.
//

import SwiftUI
import AVKit
// TODO: улучшить дизайн
// MARK: - Компоненты интерфейса

struct ModernButton: View {
    let icon: String
    let text: String
    let style: ButtonStyle
    var isDisabled: Bool = false
    let action: () -> Void
    
    enum ButtonStyle {
        case primary, secondary
        
        var backgroundColor: Color {
            switch self {
            case .primary: return .indigo
            case .secondary: return Color(.secondarySystemGroupedBackground)
            }
        }
        
        var foregroundColor: Color {
            switch self {
            case .primary: return .white
            case .secondary: return .indigo
            }
        }
    }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                Text(text)
                    .font(.subheadline.bold())
            }
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .foregroundStyle(.white)
            .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing))
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .shadow(color: Color.blue.opacity(0.3), radius: 10, x: 0, y: 5)
        }
        .disabled(isDisabled)
        .buttonStyle(.plain)
    }
}


#Preview {
    ModernButton(
        icon: "play.fill",
        text: "Play",
        style: .primary,
        action: {  }
    )
}

struct CreateMeditationView: View {
    @StateObject var viewModel = CreatePracticeViewModel()
    @State private var showConfirmationView = false
    @Environment(\.dismiss) private var dismiss

    @State private var selectedPracticeType: MeditationCategory = .daily

    @State private var title: String = ""
    @State private var description: String = ""
    @State private var therapeuticPurpose: String = ""
    @State private var frequency: String = ""
    @State private var audio: Data? = nil
    @State private var duration: TimeInterval? = nil
    @State private var image: UIImage? = nil
    @State private var isShowingPlayerPreview = false

    @State private var isShowingImagePicker: Bool = false
    @State private var isShowingAudioPicker: Bool = false
    @State private var showErrorToast = false

    private var isPracticeCanBeCreated: Bool {
        if audio != nil {
            return true
        }
        return false
    }

    private var isCreateButtonActive: Bool {
        if title != "" && description != "" && therapeuticPurpose != "" && audio != nil
            && image != nil {
            if selectedPracticeType == .restorative {
                if frequency != "" {
                    return true
                }
                return false
            }
            return true
        }
        return false
    }

    var body: some View {
        ZStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    if showErrorToast {
                        ErrorToastView(
                            message: viewModel.errorMessage ?? "Something went wrong",
                            icon: "exclamationmark.triangle.fill",
                            gradientColors: [Color.red.opacity(0.9), Color.orange.opacity(0.9)],
                            shadowColor: Color.black.opacity(0.2),
                            cornerRadius: 15,
                            shadowRadius: 10,
                            shadowOffset: CGSize(width: 0, height: 5)
                        )
                        .transition(.move(edge: .top).combined(with: .opacity))
                        .animation(.spring(response: 0.5, dampingFraction: 0.6, blendDuration: 0), value: showErrorToast)
                    }

                    PracticesTopBar(selectedTopBar: $selectedPracticeType)

                    HStack {
                        Button(action: {
                            isShowingAudioPicker = true
                        }) {
                            VStack(spacing: 12) {
                                ZStack {
                                    Circle()
                                        .fill(audio == nil ? Color(.systemGray5).opacity(0.25) : Color.indigo.opacity(0.15))
                                        .frame(width: 64, height: 64)

                                    Image(systemName: "waveform")
                                        .font(.title2)
                                        .foregroundColor(audio == nil ? .gray : .indigo)
                                        .symbolVariant(audio == nil ? .none : .fill)
                                }

                                Text(audio == nil ? "Add audio" : "Change audio")
                                    .font(.custom(CustomFonts.MarcellusRegular.rawValue, size: 14))
                                    .foregroundColor(audio == nil ? .gray : .primary)
                                    .multilineTextAlignment(.center)
                            }
                            .frame(width: 150, height: 150)
                            .background(Color(.secondarySystemGroupedBackground))
                            .cornerRadius(16)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(audio == nil ? Color.gray.opacity(0.2) : Color.indigo.opacity(0.5),
                                    lineWidth: 1
                                )
                            )
                            .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)
                        Spacer()
                        Button(action: {
                            isShowingImagePicker = true
                        }) {
                            VStack(spacing: 12) {
                                ZStack {
                                    Circle()
                                        .fill(image == nil ? Color(.systemGray5).opacity(0.25) : Color.indigo.opacity(0.15))
                                        .frame(width: 64, height: 64)

                                    Image(systemName: "photo")
                                        .font(.title2)
                                        .foregroundColor(image == nil ? .gray : .indigo)
                                        .symbolVariant(image == nil ? .none : .fill)
                                }

                                Text(image == nil ? "Add image" : "Change image")
                                    .font(.custom(CustomFonts.MarcellusRegular.rawValue, size: 14))
                                    .foregroundColor(image == nil ? .gray : .primary)
                                    .multilineTextAlignment(.center)
                            }
                            .frame(width: 150, height: 150)
                            .background(Color(.secondarySystemGroupedBackground))
                            .cornerRadius(16)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(image == nil ? Color.gray.opacity(0.2) : Color.indigo.opacity(0.5),
                                    lineWidth: 1
                                )
                            )
                            .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)

                        Spacer()
                    }
                    .padding(.horizontal)

                    // Название и описание
                    VStack(alignment: .leading, spacing: 12) {
                        NameFieldView(name: $title, placeholderName: "Title")
                        NameFieldView(name: $description, placeholderName: "Description")
                        NameFieldView(name: $therapeuticPurpose, placeholderName: "Therapeutic Purpose")

                        if selectedPracticeType == .restorative {
                            NameFieldView(name: $frequency, placeholderName: "Frequency")
                        }

                        if isPracticeCanBeCreated {
                            ModernButton(
                                icon: "play.fill",
                                text: "Listen",
                                style: .primary,
                                action: { isShowingPlayerPreview = true }
                            )
                        }

                        CustomButtonView(text: "Create", isDisabled: !isCreateButtonActive) {
                            if let compressedImage = image?.jpegData(compressionQuality: 0.8) {
                                Task {
                                    await viewModel.createPractice(request: CreatePracticeRequest(
                                        title: title,
                                        description: description,
                                        meditationType: selectedPracticeType,
                                        therapeuticPurpose: therapeuticPurpose,
                                        frequency: frequency,
                                        data: audio!,
                                        image: compressedImage))
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
            .padding()

            if viewModel.isLoading {
                Color.black.opacity(0.4) // Затемнение фона
                    .edgesIgnoringSafeArea(.all)

                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .scaleEffect(2) // Увеличение индикатора
            }

            if showConfirmationView {
                Color.black.opacity(0.4)
                    .edgesIgnoringSafeArea(.all)
                    .transition(.opacity)
                    .zIndex(1) // Убедимся, что confirmationView поверх

                PracticeConfirmationView(isVisible: $showConfirmationView)
                    .transition(.move(edge: .top).combined(with: .opacity))
                    .zIndex(1)
            }
        }
        .navigationBarTitle("Create Practice", displayMode: .inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                DarkBackButtonView()
            }
        }
        .background(Color(.systemBackground).edgesIgnoringSafeArea(.all))
        .onChange(of: viewModel.isSendSuccessfully) { _, newValue in
            if newValue {
                withAnimation {
                    showConfirmationView = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    dismiss()
                }
            }
        }
        .onChange(of: viewModel.errorMessage) { _, newValue in
            if newValue != nil {
                withAnimation {
                    showErrorToast = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    withAnimation {
                        showErrorToast = false
                    }
                }
            }
        }
        .sheet(isPresented: $isShowingImagePicker) {
            ImagePicker(image: $image)
        }
        .sheet(isPresented: $isShowingAudioPicker) {
            ImportAudioManager(data: $audio, duration: $duration)
        }
        .sheet(isPresented: $isShowingPlayerPreview) {
            PlayerView(
                audio: $audio,
                image: $image,
                title: $title,
                therapeuticPurpose: $therapeuticPurpose,
                frequency: $frequency,
                practiceId: .constant("")
            )
        }
    }
}

#Preview {
    CreateMeditationView()
}


#Preview {
    CreateMeditationView()
}

import SwiftUI

struct PracticeConfirmationView: View {
    @Binding var isVisible: Bool // Используем Binding для управления видимостью

    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            ZStack {
                Circle()
                    .fill(LinearGradient(
                        colors: [.purple.opacity(0.1), .indigo.opacity(0.1)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ))
                    .frame(width: 180, height: 180)

                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 60))
                    .foregroundStyle(LinearGradient(
                        colors: [.purple, .indigo],
                        startPoint: .leading,
                        endPoint: .trailing
                    ))
            }

            Text("Practice Saved!")
                .font(.system(.title2, design: .rounded).bold())
                .foregroundColor(.primary)

            Spacer()
        }
        .frame(maxWidth: 300, maxHeight: 300)
        .background(Color.white) // Белый фон
        .cornerRadius(20)
        .shadow(radius: 10)
        .opacity(isVisible ? 1 : 0) // Плавное изменение прозрачности
        .scaleEffect(isVisible ? 1 : 0.9) // Плавное изменение масштаба
        .animation(.easeInOut(duration: 0.4), value: isVisible) // Плавная анимация появления
        .onAppear {
            withAnimation {
                isVisible = true // Включаем видимость
            }
        }
        .onTapGesture {
            withAnimation {
                isVisible = false // Закрываем вью по нажатию
            }
        }
    }
}

#Preview {
    PracticeConfirmationView(isVisible: .constant(true))
}

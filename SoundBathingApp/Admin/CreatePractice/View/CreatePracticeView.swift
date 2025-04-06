//
//  CreatePracticeView.swift
//  SoundBathingApp
//
//  Created by Ирина Печик on 17.02.2025.
//

import SwiftUI
import AVKit

struct CreateMeditationView: View {
    @StateObject var viewModel = CreatePracticeViewModel()

    @State private var selectedPracticeType: MeditationCategory = .daily

    @State private var title: String = ""
    @State private var description: String = ""
    @State private var therapeuticPurpose: String = ""
    @State private var frequency: String = ""
    @State private var audio: Data? = nil
    @State private var duration: TimeInterval? = nil
    @State private var image: UIImage? = nil
            
    @State private var isShowingImagePicker: Bool = false
    @State private var isShowingAudioPicker: Bool = false
//    @Environment(Router.self) var router
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
        NavigationView {
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
                            .frame(height: 70)
                        
                        HStack {
                            // Кнопка выбора звука
                            Button(action: {
                                isShowingAudioPicker = true
                            }) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color(.systemGray6))
                                        .frame(width: 150, height: 150)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                        )
                                    
                                    VStack {
                                        if audio == nil {
                                            Image(systemName: "waveform")
                                                .font(.title)
                                                .foregroundColor(.gray)
                                            Text("Add audio")
                                                .font(.subheadline)
                                                .foregroundColor(.gray)
                                        } else {
                                            Image(systemName: "waveform")
                                                .font(.title)
                                                .foregroundColor(.green)
                                            Text("Change audio")
                                                .font(.subheadline)
                                                .foregroundColor(.gray)
                                        }
                                    }
                                }
                            }
                            
                            Spacer()
                            
                            Button(action: {
                                isShowingImagePicker = true
                            }) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color(.systemGray6))
                                        .frame(width: 150, height: 150)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                        )
                                    
                                    VStack {
                                        if image == nil {
                                            Image(systemName: "photo")
                                                .font(.title)
                                                .foregroundColor(.gray)
                                            Text("Add image")
                                                .font(.subheadline)
                                                .foregroundColor(.gray)
                                        } else {
                                            Image(systemName: "photo")
                                                .font(.title)
                                                .foregroundColor(.green)
                                            Text("Change image")
                                                .font(.subheadline)
                                                .foregroundColor(.gray)
                                        }
                                    }
                                }
                            }
                            
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
                            
                            VStack {
                                if isPracticeCanBeCreated {
                                    PlayerView(
                                        audio: .constant(audio!),
                                        image: $image,
                                        title: $title,
                                        therapeuticPurpose: $therapeuticPurpose,
                                        frequency: $frequency)
                                    .padding()
                                    .contentShape(Rectangle()) // Ограничиваем область нажатия
                                }
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
                .navigationTitle("Create Practice")
                .background(Color(.systemBackground).edgesIgnoringSafeArea(.all))
                .onChange(of: viewModel.isSendSuccessfully) { _, newValue in
//                    if newValue {
//                        router.navigateToSwiftUIView()
//                    }
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
                .padding()
                .sheet(isPresented: $isShowingImagePicker) {
                    ImagePicker(image: $image)
                }
                .sheet(isPresented: $isShowingAudioPicker) {
                    ImportAudioManager(data: $audio, duration: $duration)
                }
                
                
                if viewModel.isLoading {
                    Color.black.opacity(0.4) // Затемнение фона
                        .edgesIgnoringSafeArea(.all)
                    
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(2) // Увеличение индикатора
                }
            }
        }
    }
}

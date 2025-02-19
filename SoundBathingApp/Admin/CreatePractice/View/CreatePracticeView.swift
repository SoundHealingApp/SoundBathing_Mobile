//
//  CreatePracticeView.swift
//  SoundBathingApp
//
//  Created by Ирина Печик on 17.02.2025.
//

import SwiftUI
import AVKit

struct CreateMeditationView: View {
    @State private var selectedPracticeType: MeditationCategory = .daily

    @State private var title: String = ""
    @State private var description: String = ""
    @State private var therapeuticPurpose: String = ""
    @State private var frequency: String = ""

    @State private var image: UIImage? = nil
            
    @State private var isShowingImagePicker: Bool = false
    @State private var isShowingAudioPicker: Bool = false
    
    @StateObject var vm = CreatePracticeViewModel()
    
    private var isPracticeCanBeCreated: Bool {
        if vm.song != nil {
            if title != "" && description != "" && therapeuticPurpose != "" {
                if (selectedPracticeType == .restorative) {
                    if (frequency == "") {
                        return false
                    }
                }
                return true
            }
            return false
        }
        return false
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    PracticesTopBar(selectedTopBar: $selectedPracticeType)
                        .frame(height: 70)
                    
                    HStack {
                        Button(action: {
                            isShowingImagePicker = true
                        }) {
                            if let selectedImage = image {
                                Image(uiImage: selectedImage)
                                    .resizable()
                                    .scaledToFill() // Растягиваем изображение пропорционально
                                    .frame(width: 200, height: 200) // Уменьшенный размер изображения
                                    .clipped() // Обрезаем лишнее
                                    .cornerRadius(12)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                    )
                            } else {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color(.systemGray6))
                                        .frame(width: 200, height: 200) // Уменьшенный размер поля
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                        )
                                    
                                    VStack {
                                        Image(systemName: "photo")
                                            .font(.largeTitle)
                                            .foregroundColor(.gray)
                                        Text("Add image")
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                    }
                                }
                            }
                        }
                        
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
                                    Image(systemName: "waveform")
                                        .font(.title)
                                        .foregroundColor(.gray)
                                    Text("Add audio")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    // Название и описание
                    VStack(alignment: .leading, spacing: 12) {
                        NameFieldView(name: $title, placeholderName: "Title")
                        NameFieldView(name: $description, placeholderName: "Description")
                        NameFieldView(name: $therapeuticPurpose, placeholderName: "TherapeuticPurpose")
                    }
                    .padding(.horizontal)
                    
                    if selectedPracticeType == .restorative {
                        VStack(alignment: .leading, spacing: 12) {
                            NameFieldView(name: $frequency, placeholderName: "Frequency")
                        }
                        .padding(.horizontal)
                    }
                    
                    if let song = vm.song {
                        let model = PracticeSongModel(
                            title: title,
                            description: description,
                            meditationType: selectedPracticeType,
                            therapeuticPurpose: therapeuticPurpose,
                            frequency: frequency,
                            data: song.data,
                            image: image,
                            duration: song.duration)
                        
                        PracticeSongCell(song: model, durationFormated: vm.formateDuration)
                            .onTapGesture {
                                vm.playAudio(practiceSong: song)
                            }
                    }
                    
                    CustomButtonView(text: "Create", isDisabled: false) {

                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("Create Practice")
            .background(Color(.systemBackground).edgesIgnoringSafeArea(.all))
            .sheet(isPresented: $isShowingImagePicker) {
                ImagePicker(image: $image)
            }
            .sheet(isPresented: $isShowingAudioPicker) {
                ImportAudioManager(song: $vm.song)
            }
        }
    }
}

// change
//                        PracticeSongCell(song: PracticeSongModel(
//                                title: title,
//                                description: description,
//                                meditationType: selectedPracticeType,
//                                therapeuticPurpose: therapeuticPurpose,
//                                frequency: frequency,
//                                data: nil,
//                                image: nil))


//struct CreateMeditationView_Previews: PreviewProvider {
//    static var previews: some View {
//        CreateMeditationView()
//    }
//}

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
    @State private var audio: Data? = nil
    @State private var duration: TimeInterval? = nil
    @State private var image: UIImage? = nil
            
    @State private var isShowingImagePicker: Bool = false
    @State private var isShowingAudioPicker: Bool = false
    
    private var isPracticeCanBeCreated: Bool {
        if audio != nil {
            return true
        }
        return false
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
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
                                let model = PracticeSongModel(
                                    title: title,
                                    description: description,
                                    meditationType: selectedPracticeType,
                                    therapeuticPurpose: therapeuticPurpose,
                                    frequency: frequency,
                                    data: audio!,
                                    image: image,
                                    duration: duration!)
                                
                                MiniPlayerView(song: model)
                                    .padding()
                                    .contentShape(Rectangle()) // Ограничиваем область нажатия
                            }
                        }
                        
                        CustomButtonView(text: "Create", isDisabled: false) {

                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
            .navigationTitle("Create Practice")
            .background(Color(.systemBackground).edgesIgnoringSafeArea(.all))
            .sheet(isPresented: $isShowingImagePicker) {
                ImagePicker(image: $image)
            }
            .sheet(isPresented: $isShowingAudioPicker) {
                ImportAudioManager(data: $audio, duration: $duration)
            }
        }
    }
}


//struct CreateMeditationView_Previews: PreviewProvider {
//    static var previews: some View {
//        CreateMeditationView()
//    }
//}

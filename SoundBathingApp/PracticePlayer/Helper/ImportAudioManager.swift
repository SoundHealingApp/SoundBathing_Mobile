//
//  HelperFileManager.swift
//  SoundBathingApp
//
//  Created by Ирина Печик on 18.02.2025.
//

import Foundation
import SwiftUI
import AVFoundation

/// Выбор аудиофайлов и импорт их в приложение
struct ImportAudioManager: UIViewControllerRepresentable {
    @Binding var data: Data?
    @Binding var duration: TimeInterval?

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: [.audio])
        
        picker.allowsMultipleSelection = false
        picker.shouldShowFileExtensions = true
        picker.delegate = context.coordinator
        
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    
    /// Связующее звено между UIDocumentPicker и ImportFileManager
    class Coordinator: NSObject, UIDocumentPickerDelegate {
        var parent: ImportAudioManager
        
        init(parent: ImportAudioManager) {
            self.parent = parent
        }
        
        /// Вызывается при выборе документа (песни)
        /// Метод обрабатывает выбранных URL и создает песню и потом добавляет песню в переменную song
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            
            /// безопасно извлекает элемент из массива urls.
            /// startAccessingSecurityScopedResource - открывает доступ к файлу
            guard let url = urls.first, url.startAccessingSecurityScopedResource() else { return }
            
            /// Закрывает доступ к файлу
            defer { url.stopAccessingSecurityScopedResource() }
            
            do {
                /// Получение данных файла
                let document = try Data(contentsOf: url)
                
                /// Создание Asset для извлечения метаданных
                let asset = AVAsset(url: url)
                
                Task {
                    let duration = try await asset.load(.duration)
                    let transformedDuration = CMTimeGetSeconds(duration)

                    DispatchQueue.main.async {
                        self.parent.data = document
                        self.parent.duration = transformedDuration
                    }
                 }
                
            } catch {
                print("Error processing the song file: \(error)")
            }
        }
    }
}

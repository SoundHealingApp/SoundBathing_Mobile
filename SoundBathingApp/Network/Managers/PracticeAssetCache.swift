//
//  PracticeAssetCache.swift
//  SoundBathingApp
//
//  Created by Ирина Печик on 06.04.2025.
//

import Foundation
import UIKit

final class PracticeAssetCache {
    static let shared = PracticeAssetCache()
    
    private let imageCache = NSCache<NSString, UIImage>()
    private let audioCache = NSCache<NSString, NSData>()
    
    func image(for id: String) -> UIImage? {
        imageCache.object(forKey: id as NSString)
    }
    
    func audio(for id: String) -> Data? {
        audioCache.object(forKey: id as NSString) as Data?
    }
    
    func set(image: UIImage, for id: String) {
        imageCache.setObject(image, forKey: id as NSString)
    }
    
    func set(audio: Data, for id: String) {
        audioCache.setObject(audio as NSData, forKey: id as NSString)
    }
}

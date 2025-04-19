//
//  YouTubePlayerView.swift
//  SoundBathingApp
//
//  Created by Ирина Печик on 12.04.2025.
//

import WebKit
import SwiftUI

struct YouTubePlayerView: UIViewRepresentable {
    let videoID: String
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.scrollView.isScrollEnabled = false
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        guard let url = URL(string: "https://www.youtube.com/embed/\(videoID)?playsinline=1?autoplay=1") else { return }
        let request = URLRequest(url: url)
        uiView.load(request)
    }
}

#Preview {
    YouTubePlayerView(videoID: "Affh1xGriY8")
}

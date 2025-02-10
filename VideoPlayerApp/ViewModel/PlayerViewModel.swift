//
//  PlayerViewModel.swift
//  VideoPlayerApp
//
//  Created by Apple on 10/02/25.
//

import AVKit
import Combine

class PlayerViewModel: ObservableObject {
    @Published var isPlaying = false
    @Published var currentTime: Double = 0
    @Published var showControls = true
    @Published var isEditingProgress = false
    @Published var thumbnailTime: Double = 0
    
    private var cancellables = Set<AnyCancellable>()
    let videoData: VideoData
    
    init(videoData: VideoData) {
        self.videoData = videoData
    }
    
    @Published var isLoading: Bool = true
    var player: AVPlayer?
    private var statusObserver: AnyCancellable?
    
    func loadVideo(from url: URL) {
        isLoading = true
        player = AVPlayer(url: url)
        statusObserver = player?.currentItem?.publisher(for: \.status)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] status in
                if status == .readyToPlay {
                    self?.isLoading = false
                } else if status == .failed {
                    self?.isLoading = false
                    print("Failed to load video.")
                }
            }
    }
}

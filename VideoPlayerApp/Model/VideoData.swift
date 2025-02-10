//
//  VideoData.swift
//  VideoPlayerApp
//
//  Created by Apple on 10/02/25.
//
import SwiftUI
struct VideoData {
    let title: String
    let episode: String
    let description: String
    let videoURL: URL
    let duration: Double
    static let sampleData = VideoData(
        title: "Silo",
        episode: "Freedom Day",
        description: "Sheriff Becker's plans...",
        videoURL: URL(string: "https://sample-videos.com/video123/mp4/720/big_buck_bunny_720p_1mb.mp4")!,
        duration: 1200
    )
}


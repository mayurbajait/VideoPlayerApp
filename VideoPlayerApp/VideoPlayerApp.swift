//
//  VideoPlayerAppApp.swift
//  VideoPlayerApp
//
//  Created by Apple on 10/02/25.
//

import SwiftUI

// VideoPlayerApp.swift
@main
struct VideoPlayerApp: App {
    var body: some Scene {
        WindowGroup {
            PlayerView(vm: PlayerViewModel (videoData: .sampleData))
                .preferredColorScheme(.dark)
        }
    }
}

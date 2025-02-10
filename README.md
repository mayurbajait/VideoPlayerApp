# VideoPlayerApp

A modern iOS video player application built with SwiftUI and AVKit, featuring a responsive UI, analytics, and content sections.

## Features

- *Video Player*
  - Integrated AVKit video playback
  - Custom controls overlay (PiP, AirPlay, volume)
  - Dynamic video size adjustment during scrolling

- *Content Tabs*
  - **Info Tab**: Episode details and synopsis
  - **InSight Tab**: 
    - View/like/comment statistics
    - Top comments section
  - **Continue Watching Tab**: 
    - Horizontal scroll of progress-based cards
    - Mock data implementation

- *UI Features*
  - Custom header with system icons
  - Responsive layout that adapts to scroll position
  - Dark mode enabled
  - Status bar hidden during playback

## Setup Instructions

1. *Requirements*
   - Xcode 12+
   - iOS 14+
   - Swift 5.3+

2. *Installation*
   ```bash
   git clone https://github.com/your-username/VideoPlayerApp.git
   open VideoPlayerApp.xcodeproj
Build and run on simulator or physical device


## Important Notes

*Video Source*
Currently uses hardcoded URL: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4"

Replace with your own video URL in PlayerView.swift

*Configuration*
No external dependencies required
Uses native AVKit framework

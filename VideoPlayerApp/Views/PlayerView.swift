//
//  PlayerView.swift
//  VideoPlayerApp
//
//  Created by Apple on 10/02/25.
//

import SwiftUI
import AVKit

struct PlayerView: View {
    @StateObject var vm: PlayerViewModel
    @State private var previewProgress: CGFloat = 0
    @State private var showMoreInfo = false
    @State private var selectedTab: String = "Info"
    @State private var scrollOffset: CGFloat = 0
    private let maxVideoHeight: CGFloat = UIScreen.main.bounds.height * 0.6
    @State private var spacerHeight: CGFloat = 100
    private let minVideoHeight: CGFloat = 150
    
    var body: some View {
        GeometryReader { mainGeo in
            VStack(spacing: 30) {
            Spacer()
            CustomHeaderView()
                VStack(spacing: 0) {
                    Spacer()
                        .frame(height: spacerHeight)
                    
                    VStack(spacing: 0) {
                        if let url = URL(string: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4") {
                            VideoPlayer(player: vm.player)
                                .aspectRatio(16/9, contentMode: .fit)
                                .frame(width: mainGeo.size.width, height: 350)
                                .onAppear {
                                    vm.loadVideo(from: url)
                                }
                                .background(
                                    GeometryReader { proxy in
                                        Color.clear
                                            .preference(
                                                key: ScrollOffsetKey.self,
                                                value: proxy.frame(in: .named("scroll")).minY
                                            )
                                    }
                                )
                        }
                    }
                    .frame(height: 350)
                    
                    Spacer()
                        .frame(height: spacerHeight)
                    
                    ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        VStack(alignment: .leading, spacing: 0) {
                            Text("Breaking Bad")
                                .font(.title2.bold())
                            Text("S01 E07 · A No-Rough-Stuff-Type Deal")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            
                        }
                        .padding()
                        .background(Color.black)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        HStack(spacing: 20) {
                            CustomButton(title: "Info", selectedTab: $selectedTab)
                            CustomButton(title: "InSight", selectedTab: $selectedTab)
                            CustomButton(title: "Continue Watching", selectedTab: $selectedTab)
                        }
                        .padding(.vertical)
                        .background(Color.black)
                        .background(
                            GeometryReader { proxy in
                                Color.black
                                    .frame(height: mainGeo.safeAreaInsets.top)
                                    .frame(maxWidth: .infinity)
                                    .offset(y: -proxy.frame(in: .global).minY)
                            }
                        )
                        TabContentView(selectedTab: $selectedTab)
                            .background(Color.black)
                    }
                }
                    .coordinateSpace(name: "scroll")
                    .onPreferenceChange(ScrollOffsetKey.self) { value in
                        scrollOffset = value
                        print(value)
                        if value < 150 {
                            spacerHeight = value
                        }
                    }
            }
        }
            .edgesIgnoringSafeArea(.vertical)
        }
        .preferredColorScheme(.dark)
        .statusBarHidden(true)
    }
    
    private var videoHeight: CGFloat {
        let progress = -scrollOffset / (maxVideoHeight - minVideoHeight)
        return max(maxVideoHeight - (-scrollOffset * 0.8), minVideoHeight)
    }
        
        
        private var insightContent: some View {
            VStack(alignment: .leading, spacing: 12) {
                Text("InSight Analytics")
                    .font(.headline.bold())
                
                HStack {
                    StatView(icon: "eye.fill", value: "1.2M", label: "Views")
                    StatView(icon: "hand.thumbsup.fill", value: "98K", label: "Likes")
                    StatView(icon: "message.fill", value: "4.3K", label: "Comments")
                }
                
                Text("Top Comments")
                    .font(.subheadline.bold())
                    .padding(.top, 8)
                
                CommentView(author: "MovieFan92", text: "This is absolutely stunning cinematography!")
                CommentView(author: "FilmCriticPro", text: "Remarkable character development throughout.")
            }
            .padding()
            .background(Color.black.opacity(0.7))
            .cornerRadius(12)
            .padding(.horizontal)
        }
    
    private var videoOverlay: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [.black.opacity(0.4), .clear]),
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(height: 150)
            
            LinearGradient(
                gradient: Gradient(colors: [.clear, .black.opacity(0.6)]),
                startPoint: .top,
                endPoint: .bottom
            )
        }
    }
}

struct CustomHeaderView: View {
    var body: some View {
        HStack {
            Button(action: {
                print("Close tapped")
            }) {
                Image(systemName: "xmark")
                    .foregroundColor(.white)
            }
            
            Spacer()
        
            Button(action: {
                print("PiP Icon tapped")
            }) {
                Image(systemName: "rectangle.inset.filled.and.arrow.top.right")
                    .foregroundColor(.white)
            }
            
            Button(action: {
                print("airplayvideo tapped")
            }) {
                Image(systemName: "airplayvideo")
                    .foregroundColor(.white)
            }
            
            Spacer()
            
            Button(action: {
                print("Volume tapped")
            }) {
                Image(systemName: "speaker.wave.2.fill")
                    .foregroundColor(.white)
            }
        }
        .padding()
        .background(Color.black)
    }
}

struct CustomButton: View {
    let title: String
    @Binding var selectedTab: String
    
    var body: some View {
        Button(action: {
            selectedTab = title
        }) {
            Text(title)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(selectedTab == title ? Color.white : Color.clear)
                .foregroundColor(selectedTab == title ? .black : .white)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.white, lineWidth: 1)
                )
        }
    }
}

struct StatView: View {
    let icon: String
    let value: String
    let label: String
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: icon)
                Text(value)
                    .fontWeight(.medium)
            }
            Text(label)
                .font(.caption2)
                .opacity(0.8)
        }
        .frame(width: 100)
        .padding(8)
        .background(Color.black.opacity(0.5))
        .cornerRadius(8)
    }
}

struct CommentView: View {
    let author: String
    let text: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(author)
                .font(.caption)
                .bold()
                .foregroundColor(.blue)
            
            Text(text)
                .font(.caption)
                .lineLimit(2)
        }
        .padding(8)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.black.opacity(0.3))
        .cornerRadius(8)
    }
}

struct ContinueWatching: Identifiable {
    let id = UUID()
    let title: String
    let progress: Double

    static let sampleData = [
        ContinueWatching(title: "The Reckoning", progress: 0.65),
        ContinueWatching(title: "The Reckoning", progress: 0.35),
        ContinueWatching(title: "The Reckoning", progress: 0.82),
        ContinueWatching(title: "The Reckoning", progress: 0.15)
    ]
}

struct ScrollOffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value += nextValue()
    }
}

struct TabContentView: View {
    @Binding var selectedTab: String

    var body: some View {
        Group {
            switch selectedTab {
            case "Info":
                EpisodeInfoView()
            case "InSight":
                InSightView()
            case "Continue Watching":
                ContinueWatchingView()
            default:
                EmptyView()
            }
        }
        .animation(.easeInOut, value: selectedTab)
    }
}

struct EpisodeInfoView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Episode Details")
                .font(.headline)

            Text("Walter accepts his new identity as a drug dealer after a PTA meeting. Elsewhere, Jesse decides to put his aunt's house on the market, and Skyler is the recipient of a baby shower")
                .font(.body)
                .lineSpacing(4)

            HStack {
                Text("Released 9 Mar 2008")
            }
            .foregroundColor(.gray)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}


struct InSightView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("InSight Analytics")
                .font(.title3.bold())
                .padding(.horizontal)

            HStack(spacing: 15) {
                StatCard(icon: "eye.fill", value: "1.2M", label: "Views")
                StatCard(icon: "hand.thumbsup.fill", value: "98K", label: "Likes")
                StatCard(icon: "message.fill", value: "4.3K", label: "Comments")
            }
            .padding(.horizontal)

            VStack(alignment: .leading, spacing: 12) {
                Text("Top Comments")
                    .font(.headline)

                CommentRow(author: "MovieFan92", comment: "This is absolutely stunning cinematography!", likes: "1.2K")
                CommentRow(author: "FilmCriticPro", comment: "Remarkable character development throughout.", likes: "892")
                CommentRow(author: "Cinephile007", comment: "Best episode of the season so far!", likes: "765")
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
            .padding(.horizontal)

            Spacer()
        }
        .padding(.top)
        .foregroundColor(.white)
    }
}


struct ContinueWatchingView: View {
    let items = ContinueWatching.sampleData

    var body: some View {
        VStack(alignment: .leading) {
            Text("Continue Watching")
                .font(.headline)
                .padding(.horizontal)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(items) { item in
                        ContinueWatchingCard(item: item)
                    }
                }
                .padding(.horizontal)
            }
        }
        .padding(.vertical)
    }
}


struct StatCard: View {
    let icon: String
    let value: String
    let label: String

    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Image(systemName: icon)
                Text(value)
                    .fontWeight(.medium)
            }
            .font(.system(size: 18))

            Text(label)
                .font(.caption)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
        .padding(12)
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
}


struct ContinueWatchingCard: View {
    let item: ContinueWatching

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack(alignment: .bottomLeading) {
                RoundedRectangle(cornerRadius: 8)
                    .frame(width: 160, height: 90)
                    .foregroundColor(Color(.systemGray4))

            }

            Text(item.title)
                .font(.caption)
                .lineLimit(1)

            Text("\(Int(item.progress * 100))% watched")
                .font(.caption2)
                .foregroundColor(.gray)
        }
        .frame(width: 160)
    }
}


struct CommentRow: View {
    let author: String
    let comment: String
    let likes: String

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: "person.circle.fill")
                .font(.system(size: 24))
                .foregroundColor(.gray)

            VStack(alignment: .leading, spacing: 4) {
                Text(author)
                    .font(.caption)
                    .bold()

                Text(comment)
                    .font(.body)
                    .lineLimit(2)

                HStack {
                    Image(systemName: "heart.fill")
                        .foregroundColor(.red)
                    Text(likes)
                        .font(.caption)
                }
                .padding(.top, 4)
            }

            Spacer()
        }
        .padding(12)
        .background(Color.black.opacity(0.8))
        .cornerRadius(8)
    }
}

//
//  WorkoutVideoPlayer.swift
//  FirebaseAuthenticationSwiftUIPractice
//
//  Created by Rakesh Shrestha on 24/01/2025.
//

import SwiftUI
import AVKit

struct WorkoutVideoPlayerView: View {
    
    //    @State private var player: AVPlayer = AVPlayer(url: <#T##URL#>)
    
    @State private var player: AVPlayer? = {
        if let bundle = Bundle.main.path(forResource: "sampleVideo", ofType: "mp4") {
            return .init(url: URL(filePath: bundle))
        }
        return nil
    }()
    
    @State private var showPlayerControls: Bool = false
    @State private var isPlaying: Bool = true
    @State private var isSeeking: Bool = false
    @State private var isFinishedPlaying: Bool = false
    
    @State private var timeoutTask: DispatchWorkItem?
    
    @GestureState private var isDragging: Bool = false
    @State private var progress: CGFloat = 0
    @State private var lastDraggedProgress: CGFloat = 0
    
    var body: some View {
        VStack(alignment: .leading) {
            let videoPlayerSize: CGSize = .init(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.8)
            
            BackButton()
                .padding(.leading, 36)
                .padding(.top, 24)
            
            Spacer()
            
            ZStack {
                if let player {
                    CustomVideoPlayer(player: player)
                        .overlay {
                            Rectangle()
                                .fill(Color.black.opacity(0.4))
                                .opacity(showPlayerControls || isDragging ? 1 : 0)
                                .animation(.easeInOut(duration: 0.35), value: isDragging)
                                .overlay {
                                    PlaybackControls()
                                }
                        }
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 0.35)) {
                                showPlayerControls.toggle()
                            }
                            if isPlaying {
                                timeoutControls()
                            }
                        }
                        .overlay(alignment: .bottom) {
                            VideoSeekerView(videoPlayerSize)
                        }
                }
            }
            .frame(width: videoPlayerSize.width, height: videoPlayerSize.height)
            .padding(.bottom, 60)
            .onAppear {
                player?.play()
                player?.addPeriodicTimeObserver(forInterval: .init(seconds: 1, preferredTimescale: 1), queue: .main, using: { time in
                    if let currentPlayerItem = player?.currentItem {
                        let totalDuration = currentPlayerItem.duration.seconds
                        guard let currentDuration = player?.currentTime().seconds else { return }
                        let calculatedProgress = currentDuration / totalDuration
                        
                        if !isSeeking {
                            progress = calculatedProgress
                            lastDraggedProgress = progress
                        }
                        
                        if calculatedProgress == 1 {
                            isFinishedPlaying = true
                            isPlaying = false
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                                showPlayerControls = true
                            })
                        }
                    }
                })
            }
        }
        .background(Color.black)
    }
    
    @ViewBuilder
    func VideoSeekerView(_ videoSize: CGSize) -> some View {
        ZStack(alignment: .leading) {
            Rectangle()
                .fill(.gray)
            
            Rectangle()
                .fill(Color.init(hex: "F97316"))
                .frame(width: max(UIScreen.main.bounds.width * progress, 0))
        }
        .frame(height: 7)
        .overlay(alignment: .leading) {
            Circle()
                .fill(Color.red)
                .frame(width: 30, height: 30)
                .scaleEffect(showPlayerControls || isDragging ? 1 : 0.001, anchor: progress * UIScreen.main.bounds.width > 30 ? .trailing : .leading)
                .offset(x: UIScreen.main.bounds.width * progress)
                .gesture(
                    DragGesture()
                        .updating($isDragging, body: { _, out, _ in
                            out = true
                        })
                        .onChanged({ value in
                            
                            if let timeoutTask {
                                timeoutTask.cancel()
                            }
                            
                            let translationX = value.translation.width
                            let calculatedProgress = (translationX / UIScreen.main.bounds.width) + lastDraggedProgress
                            progress = max(min(calculatedProgress, 1), 0)
                            
                            isSeeking = true
                        })
                        .onEnded({ value in
                            lastDraggedProgress = progress
                            
                            if let currentPlayerTime = player?.currentItem {
                                let totalDuration = currentPlayerTime.duration.seconds
                                player?.seek(to: .init(seconds: totalDuration * progress, preferredTimescale: 1))
                            }
                            
                            if isPlaying {
                                timeoutControls()
                            }
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                                isSeeking = false
                            })
                            
                        })
                )
                .offset(x: progress * UIScreen.main.bounds.width > 30 ? -30 : 0)
                .frame(width: 30, height: 30)
        }
    }
    
    @ViewBuilder
    func PlaybackControls() -> some View {
        HStack(spacing: 25) {
            
            Button {
                
                if isFinishedPlaying {
                    isFinishedPlaying = false
                    player?.seek(to: .zero)
                    progress = .zero
                    lastDraggedProgress = .zero
                }
                
                if isPlaying {
                    player?.pause()
                    
                    if let timeoutTask {
                        timeoutTask.cancel()
                    }
                    
                } else {
                    player?.play()
                    timeoutControls()
                }
                
                withAnimation(.easeInOut(duration: 0.2)) {
                    isPlaying.toggle()
                    
                }
                
            } label: {
                Image(systemName: isFinishedPlaying ? "arrow.clockwise" : (isPlaying ? "pause.fill" : "play.fill"))
                    .font(.title2)
                    .foregroundStyle(.white)
                    .padding(15)
                    .background {
                        Circle()
                            .fill(.black.opacity(0.4))
                    }
            }
            .scaleEffect(1.1)
            
            
        }
        .opacity(showPlayerControls && !isDragging ? 1 : 0)
        .animation(.easeInOut, value: showPlayerControls && !isDragging)
    }
    
    func timeoutControls() {
        
        if let timeoutTask {
            timeoutTask.cancel()
        }
        
        timeoutTask = .init(block: {
            withAnimation(.easeInOut(duration: 0.35)) {
                showPlayerControls = false
            }
        })
        
        if let timeoutTask {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: timeoutTask)
        }
        
    }
}

struct WorkoutVideoPlayerView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutVideoPlayerView()
    }
}

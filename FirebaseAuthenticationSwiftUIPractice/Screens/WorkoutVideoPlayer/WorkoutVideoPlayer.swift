//
//  WorkoutVideoPlayer.swift
//  FirebaseAuthenticationSwiftUIPractice
//
//  Created by Rakesh Shrestha on 24/01/2025.
//

import SwiftUI
import AVKit

struct WorkoutVideoPlayerView: View {
        @State private var player: AVPlayer? = {
            if let videoUrl = URL(string: "https://res.cloudinary.com/du7pn6pke/video/upload/v1738063486/nepal%20excaliber/Anime_vid_template6-VEED_pbsnnc.mp4") {
                return AVPlayer(url: videoUrl)
            }
            else {
                return nil
            }
        }()
    
//    @State private var player: AVPlayer? = {
//        if let bundle = Bundle.main.path(forResource: "sampleVideo", ofType: "mp4") {
//            return .init(url: URL(filePath: bundle))
//        }
//        return nil
//    }()
    
    @State private var showPlayerControls: Bool = false
    @State private var isPlaying: Bool = true
    @State private var isSeeking: Bool = false
    @State private var isFinishedPlaying: Bool = false
    
    @State private var timeoutTask: DispatchWorkItem?
    
    @GestureState private var isDragging: Bool = false
    @State private var progress: CGFloat = 0
    @State private var lastDraggedProgress: CGFloat = 0
    
    @State private var isObserverAdded: Bool = false
    @State private var thumnailFrames: [UIImage] = []
    @State private var draggingImage: UIImage?
    @State private var playerStatusObserver: NSKeyValueObservation?
    
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
                        .overlay{
                            if !isFinishedPlaying {
                                HStack(spacing: 60) {
                                    DoubleTapSeek {
                                        let seconds = player.currentTime().seconds - 5
                                        player.seek(to: .init(seconds: seconds, preferredTimescale: 600))
                                    }
                                    DoubleTapSeek(isForward: true) {
                                        let seconds = player.currentTime().seconds + 5
                                        player.seek(to: .init(seconds: seconds, preferredTimescale: 600))
                                    }
                                }
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
                        .overlay(alignment: .bottomLeading, content: {
                            SeekerThumbnailView(videoPlayerSize)
                        })
                        .overlay(alignment: .bottom) {
                            VideoSeekerView(videoPlayerSize)
                        }
                }
            }
            .frame(width: videoPlayerSize.width, height: videoPlayerSize.height)
            .padding(.bottom, 60)
            .onAppear {
                
                guard !isObserverAdded else { return }
                
                player?.play()
                player?.addPeriodicTimeObserver(forInterval: .init(seconds: 1, preferredTimescale: 600), queue: .main, using: { time in
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
                
                isObserverAdded = true
                
                playerStatusObserver = player?.observe( \.status, options: .new, changeHandler: { player, _ in
                    if player.status == .readyToPlay {
                        generateThumbnailFrames()
                    }
                })
            }
            .onDisappear {
                playerStatusObserver?.invalidate()
            }
        }
        .background(Color.black)
    }
    
    
    @ViewBuilder
    func SeekerThumbnailView(_ videoSize: CGSize) -> some View {
        let thumbSize: CGSize = .init(width: 100, height: 150)
        ZStack {
            if let draggingImage {
                Image(uiImage: draggingImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
                    .overlay(alignment: .bottom, content: {
                        if let currentItem = player?.currentItem {
                            Text(CMTime(seconds: progress * currentItem.duration.seconds, preferredTimescale: 600).toTimeString())
                                .font(.callout)
                                .fontWeight(.semibold)
                                .foregroundStyle(.white)
                                .offset(y: 25)
                        }
                    })
                    .overlay {
                        RoundedRectangle(cornerRadius: 15, style: .continuous)
                            .stroke(.white, lineWidth: 2)
                    }
            }
            else {
                RoundedRectangle(cornerRadius: 15, style: .continuous)
                    .fill(.black).overlay {
                        RoundedRectangle(cornerRadius: 15, style: .continuous)
                            .stroke(.white, lineWidth: 2)
                    }
            }
        }
        .frame(width: thumbSize.width, height: thumbSize.height)
        .opacity(isDragging ? 1 : 0)
        .offset(x: progress * (videoSize.width - thumbSize.width - 20))
        .padding(.bottom, 44)
    }
    
    @ViewBuilder
    func VideoSeekerView(_ videoSize: CGSize) -> some View {
        ZStack(alignment: .leading) {
            Rectangle()
                .fill(.gray)
                .frame(height: 4)
            
            Rectangle()
                .fill(Color.init(hex: "F97316"))
                .frame(width: max(UIScreen.main.bounds.width * progress, 0))
                .frame(height: 4)
            
            Rectangle()
                .fill(.black.opacity(0.0001))
                .frame(height: 30)
        }
        .onTapGesture { location in
            let totalWidth = videoSize.width
            let tappedProgress = location.x / totalWidth
            
            // Clamp the progress between 0 and 1
            progress = max(min(tappedProgress, 1), 0)
            lastDraggedProgress = progress

            // Seek the video to the new progress
            if let currentPlayerItem = player?.currentItem {
                let totalDuration = currentPlayerItem.duration.seconds
                player?.seek(to: CMTime(seconds: totalDuration * progress, preferredTimescale: 600))
            }
            
            // Reset timeout if playing
            if isPlaying {
                timeoutControls()
            }
            withAnimation(.easeInOut(duration: 0.2).delay(0.4)) {
                    showPlayerControls = true
            }
        }
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
                            
                            if isFinishedPlaying {
                                isFinishedPlaying = false
                            }
                            
                            if let timeoutTask {
                                timeoutTask.cancel()
                            }
                            
                            let translationX = value.translation.width
                            let calculatedProgress = (translationX / UIScreen.main.bounds.width) + lastDraggedProgress
                            progress = max(min(calculatedProgress, 1), 0)
                            
                            isSeeking = true
                            
                            let dragIndex = Int(progress / 0.01)
                            
                            if thumnailFrames.indices.contains(dragIndex) {
                                draggingImage = thumnailFrames[dragIndex]
                            }
                        })
                        .onEnded({ value in
                            lastDraggedProgress = progress
                            
                            if let currentPlayerTime = player?.currentItem {
                                let totalDuration = currentPlayerTime.duration.seconds
                                player?.seek(to: .init(seconds: totalDuration * progress, preferredTimescale: 600))
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
    
    func generateThumbnailFrames() {
        Task.detached {
            guard let asset = await player?.currentItem?.asset else { return }
            let generator = AVAssetImageGenerator(asset: asset)
            generator.appliesPreferredTrackTransform = true
            generator.maximumSize = .init(width: 250, height: 250)
            
            do {
                let totalDuration = try await  asset.load(.duration).seconds
                var frameTimes: [CMTime] = []
                // 1/0.01 = 100 frames
                for progress in stride(from: 0, to: 1, by: 0.01) {
                    let time = CMTime(seconds: progress * totalDuration, preferredTimescale: 600)
                    frameTimes.append(time)
                }
                
                for await result in generator.images(for: frameTimes) {
                    let cgImage = try result.image
                    await MainActor.run(body: {
                        thumnailFrames.append(UIImage(cgImage: cgImage))
                    })
                }
                
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

struct WorkoutVideoPlayerView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutVideoPlayerView()
    }
}

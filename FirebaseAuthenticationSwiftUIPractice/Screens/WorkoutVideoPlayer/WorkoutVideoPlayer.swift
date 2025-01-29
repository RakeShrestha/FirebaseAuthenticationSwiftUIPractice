import SwiftUI
import AVKit

struct WorkoutVideoPlayerView: View {
    
    let videoURL: String
        
        // MARK: - State Variables
        @State private var player: AVPlayer?
        
        init(videoURL: String) {
            self.videoURL = videoURL
        }
    
//    @State private var player: AVPlayer? = {
//        if let videoUrl = URL(string: videoUrl) {
//            return AVPlayer(url: videoUrl)
//        } else {
//            return nil
//        }
//    }()
    
    // Control States
    @State private var showPlayerControls: Bool = false
    @State private var isPlaying: Bool = true
    @State private var isSeeking: Bool = false
    @State private var isFinishedPlaying: Bool = false
    
    // Timeout task for hiding controls after a period of inactivity
    @State private var timeoutTask: DispatchWorkItem?
    
    // For tracking dragging state and progress during seeking
    @GestureState private var isDragging: Bool = false
    @State private var progress: CGFloat = 0
    @State private var lastDraggedProgress: CGFloat = 0
    
    // States for observing player status and managing thumbnail frames
    @State private var isObserverAdded: Bool = false
    @State private var thumnailFrames: [UIImage] = []
    @State private var draggingImage: UIImage?
    @State private var playerStatusObserver: NSKeyValueObservation?
    
    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading) {
            let videoPlayerSize: CGSize = .init(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.8)
            
            BackButton()
                .padding(.leading, 36)
                .padding(.top, 24)
            
            Spacer()
            
            VideoPlayerContainer(player: player, videoPlayerSize: videoPlayerSize)
            
            .onAppear {
                setupPlayer()
            }
            .onDisappear {
                cleanupPlayerObservers()
            }
        }
        .background(Color.black)
    }
    
    // MARK: - Setup AVPlayer
        private func setupPlayer() {
            if let url = URL(string: videoURL) {
                player = AVPlayer(url: url)
                setupPlayerObservers()
            } else {
                print("Invalid URL string")
            }
        }
    
    // MARK: - Setup Player Observers
    private func setupPlayerObservers() {
        guard !isObserverAdded else { return }
        
        player?.play()
        addPeriodicTimeObserver()
        observePlayerStatus()
        
        isObserverAdded = true
    }
    
    // MARK: - Cleanup Player Observers
    private func cleanupPlayerObservers() {
        playerStatusObserver?.invalidate()
    }
    
    // MARK: - Add Periodic Time Observer
    private func addPeriodicTimeObserver() {
        player?.addPeriodicTimeObserver(forInterval: .init(seconds: 1, preferredTimescale: 600), queue: .main) { time in
            handleTimeObserverUpdate(time)
        }
    }
    
    // MARK: - Handle Time Observer Update
    private func handleTimeObserverUpdate(_ time: CMTime) {
        guard let currentPlayerItem = player?.currentItem else { return }
        
        let totalDuration = currentPlayerItem.duration.seconds
        let currentDuration = player?.currentTime().seconds ?? 0
        let calculatedProgress = currentDuration / totalDuration
        
        // Update progress unless the user is seeking
        if !isSeeking {
            progress = calculatedProgress
            lastDraggedProgress = progress
        }
        
        // Handle video finish
        if calculatedProgress == 1 {
            finishVideoPlayback()
        }
    }
    
    // MARK: - Finish Video Playback
    private func finishVideoPlayback() {
        isFinishedPlaying = true
        isPlaying = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            showPlayerControls = true
        }
    }
    
    // MARK: - Observe Player Status
    private func observePlayerStatus() {
        playerStatusObserver = player?.observe(\.status, options: .new) { player, _ in
            if player.status == .readyToPlay {
                generateThumbnailFrames()
            }
        }
    }
    
    // MARK: - Playback Controls (Play/Pause/Restart)
    @ViewBuilder
    func PlaybackControls() -> some View {
        HStack(spacing: 25) {
            playPauseButton
        }
        .opacity(showPlayerControls && !isDragging ? 1 : 0)
        .animation(.easeInOut, value: showPlayerControls && !isDragging)
    }
    
    // MARK: - Play/Pause Button
    private var playPauseButton: some View {
        Button {
            handlePlayPauseToggle()
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
    
    // MARK: - Handle Play/Pause Toggle
    private func handlePlayPauseToggle() {
        if isFinishedPlaying {
            resetVideoPlayback()
        }
        
        if isPlaying {
            player?.pause()
            timeoutTask?.cancel()
        } else {
            player?.play()
            timeoutControls()
        }
        
        withAnimation(.easeInOut(duration: 0.2)) {
            isPlaying.toggle()
        }
    }
    
    // MARK: - Reset Video Playback
    private func resetVideoPlayback() {
        isFinishedPlaying = false
        player?.seek(to: .zero)
        progress = .zero
        lastDraggedProgress = .zero
    }
    
    // MARK: - Timeout Controls for Hiding Player Controls
    func timeoutControls() {
        if let timeoutTask {
            timeoutTask.cancel()
        }
        
        timeoutTask = DispatchWorkItem {
            withAnimation(.easeInOut(duration: 0.35)) {
                showPlayerControls = false
            }
        }
        
        if let timeoutTask {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: timeoutTask)
        }
    }
    
    // MARK: - Generate Thumbnails for Seeking
    func generateThumbnailFrames() {
        Task.detached {
            guard let asset = await player?.currentItem?.asset else { return }
            let generator = AVAssetImageGenerator(asset: asset)
            generator.appliesPreferredTrackTransform = true
            generator.maximumSize = .init(width: 250, height: 250)
            
            do {
                let totalDuration = try await asset.load(.duration).seconds
                var frameTimes: [CMTime] = []
                
                // Generate frames at intervals
                for progress in stride(from: 0, to: 1, by: 0.01) {
                    let time = CMTime(seconds: progress * totalDuration, preferredTimescale: 600)
                    frameTimes.append(time)
                }
                
                for await result in generator.images(for: frameTimes) {
                    let cgImage = try result.image
                    await MainActor.run {
                        thumnailFrames.append(UIImage(cgImage: cgImage))
                    }
                }
                
            } catch {
                print("Error generating thumbnail frames: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - VideoPlayerContainer
    @ViewBuilder
    func VideoPlayerContainer(player: AVPlayer?, videoPlayerSize: CGSize) -> some View {
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
                    .overlay {
                        DoubleTapSeekButtons(player: player)
                    }
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.35)) {
                            showPlayerControls.toggle()
                        }
                        if isPlaying {
                            timeoutControls()
                        }
                    }
                    .overlay(alignment: .bottomLeading) {
                        SeekerThumbnailView(videoPlayerSize)
                    }
                    .overlay(alignment: .bottom) {
                        VideoSeekerView(videoPlayerSize)
                    }
            }
        }
        .frame(width: videoPlayerSize.width, height: videoPlayerSize.height)
        .padding(.bottom, 60)
    }
    
    // MARK: - Double Tap Seek Buttons
    @ViewBuilder
    func DoubleTapSeekButtons(player: AVPlayer) -> some View {
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
    
    // MARK: - Seeker Thumbnail View (for Scrubbing)
    @ViewBuilder
    func SeekerThumbnailView(_ videoSize: CGSize) -> some View {
        let thumbSize: CGSize = .init(width: 100, height: 150)
        ZStack {
            if let draggingImage {
                Image(uiImage: draggingImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
                    .overlay(alignment: .bottom) {
                        Text(progressTimeString)
                            .font(.callout)
                            .fontWeight(.semibold)
                            .foregroundStyle(.white)
                            .offset(y: 25)
                    }
                    .overlay {
                        RoundedRectangle(cornerRadius: 15, style: .continuous)
                            .stroke(.white, lineWidth: 2)
                    }
            } else {
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
        .padding(.bottom, 52)
    }
    
    // MARK: - Video Seeker View (for Scrubbing)
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
            handleSeekBarTap(location: location, videoSize: videoSize)
        }
        .overlay(alignment: .leading) {
            Circle()
                .fill(Color.red)
                .frame(width: 30, height: 30)
                .scaleEffect(showPlayerControls || isDragging ? 1 : 0.001, anchor: progress * UIScreen.main.bounds.width > 30 ? .trailing : .leading)
                .offset(x: UIScreen.main.bounds.width * progress)
                .gesture(
                    DragGesture()
                        .updating($isDragging) { _, out, _ in
                            out = true
                        }
                        .onChanged { value in
                            handleDragChanged(value: value)
                        }
                        .onEnded { _ in
                            handleDragEnded()
                        }
                )
                .offset(x: progress * UIScreen.main.bounds.width > 30 ? -30 : 0)
                .frame(width: 30, height: 30)
        }
    }
    
    // MARK: - Handle Seek Bar Tap
    private func handleSeekBarTap(location: CGPoint, videoSize: CGSize) {
        let totalWidth = videoSize.width
        let tappedProgress = location.x / totalWidth
        progress = max(min(tappedProgress, 1), 0)
        lastDraggedProgress = progress
        seekToCurrentProgress()
    }
    
    // MARK: - Handle Drag Changed
    private func handleDragChanged(value: DragGesture.Value) {
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
        
        updateThumbnailImageForDrag()
    }
    
    // MARK: - Update Thumbnail Image for Dragging
    private func updateThumbnailImageForDrag() {
        let dragIndex = Int(progress / 0.01)
        if thumnailFrames.indices.contains(dragIndex) {
            draggingImage = thumnailFrames[dragIndex]
        }
    }
    
    // MARK: - Handle Drag Ended
    private func handleDragEnded() {
        lastDraggedProgress = progress
        seekToCurrentProgress()
        if isPlaying {
            timeoutControls()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            isSeeking = false
        }
    }
    
    // MARK: - Seek to Current Progress
    private func seekToCurrentProgress() {
        if let currentPlayerItem = player?.currentItem {
            let totalDuration = currentPlayerItem.duration.seconds
            player?.seek(to: CMTime(seconds: totalDuration * progress, preferredTimescale: 600))
        }
    }
    
    // MARK: - Progress Time String
    private var progressTimeString: String {
        guard let currentItem = player?.currentItem else { return "00:00" }
        return CMTime(seconds: progress * currentItem.duration.seconds, preferredTimescale: 600).toTimeString()
    }
}

// MARK: - Preview
struct WorkoutVideoPlayerView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutVideoPlayerView(videoURL: "")
    }
}

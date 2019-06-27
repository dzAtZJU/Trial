//
//  VideoWithControlView.swift
//  Trial
//
//  Created by 周巍然 on 2019/3/28.
//  Copyright © 2019 周巍然. All rights reserved.
//

import Foundation
import UIKit
import YoutubePlayer_in_WKWebView

// 1. initialized
// 2. Ready to be called

// Aspect
// Ready -> 播放/暂停 指令队列
// Buffer -> 转圈圈/隐藏
// 控件

protocol VideoEventDelegate {
    func videoDidPlay(_ video: VideoWithPlayerView)
}

class VideoWithPlayerView: BasePlayerView {
    let videoView: WKYTPlayerView
    
    var screenshot: UIView? {
        didSet {
            NotificationCenter.default.post(name: NSNotification.Name.newScreenshot, object: self, userInfo: ["videoId": videoId, "screenshot": screenshot])
        }
    }
    
    private var isFirstPlayed = true
    
    private var requestToBuffer = false
    
    var isReady = false
    
    var duration: Float = 0
    
    var current: Float = 0
    
    var dataDelegate: VideoCellV2?
    
    var eventDelegate: VideoEventDelegate?
    
    static func loadVideoForWatch(videoId: VideoId) -> VideoWithPlayerView {
        let result = VideoWithPlayerView(videoId: videoId)
        return result
    }
    
    private init(videoId: VideoId) {
        videoView = WKYTPlayerView()
        videoView.isUserInteractionEnabled = false
        videoView.isHidden = true
        super.init(frame: CGRect.zero)
        isUserInteractionEnabled = false
        videoView.delegate = self
        fullSizingSubview(videoView)
        addSubview(videoView)
        self.videoId = videoId
        self.videoView.load(withVideoId: videoId, playerVars: ["controls":0, "playsinline":1, "start": 1, "modestbranding": 1, "rel": 0, "fs": 0, "iv_load_policy": 3])
        
    }
    
    func play() {
        self.requestToPlay = true
        self.videoView.playVideo()
        self.isFirstPlayed = false
    }
    
    func buffer() {
        self.requestToBuffer = true
        self.videoView.seek(toSeconds: 0, allowSeekAhead: true)
    }
    
    func endBuffer() {
        requestToBuffer = false
        self.window?.insertSubview(self, at: 0)
        self.videoView.pauseVideo()
    }
    
    /// Leave cell then pack up
    func fallOff(completion: ((VideoWithPlayerView) -> ())? = nil) {
        if isReady {
            screenshot = videoView.snapshotView(afterScreenUpdates: false)
        }
        pause()
        window?.insertSubview(self, at: 0) // remove from super view will somehow clear up the video, so instead just move to elsewhere
        
        if let completion = completion {
            completion(self)
        }
    }
    
    override func pause() {
        self.requestToPlay = false
        activityIndicator.stopAnimating()
        videoView.pauseVideo()
    }
    
    private func beforeAppear() {
        activityIndicator.stopAnimating()
        isReady = true
        videoView.isHidden = false
        eventDelegate?.videoDidPlay(self)
        if requestToBuffer && !requestToPlay {
            endBuffer()
        }
        setNeedsDisplay()
        layoutIfNeeded()
    }
    
    func getVideoState(_ block: @escaping (WKYTPlayerState) -> ()) {
        videoView.getPlayerState { (state, _) in
            block(state)
        }
    }
    
    func seekBy(_ seconds: Float) {
        videoView.getCurrentTime { (current, _) in
            self.seekTo(current + seconds, allowSeekAhead: true)
        }
    }
    
    func seekBy(scale: Float, allowSeekAhead: Bool) {
        videoView.getCurrentTime { (current, _) in
            self.seekTo(current + self.duration * scale, allowSeekAhead: allowSeekAhead)
        }
    }
    
    func seekTo(_ seconds: Float, allowSeekAhead: Bool) {
        videoView.seek(toSeconds: seconds, allowSeekAhead: allowSeekAhead)
        if allowSeekAhead {
            videoView.playVideo()
        }
    }
    
    override func togglePlay() {
        getVideoState { state in
            state == WKYTPlayerState.paused ? self.play() : self.pause()
        }
    }
    
    override func presentControl() {
        videoView.getCurrentTime { (current, _) in
            self.videoView.getPlayerState { (state, _) in
                self.playerControl = PlayerControlView.shared
                if let playerControl = self.playerControl {
                    playerControl.preparePresent(isPlaying: state != WKYTPlayerState.paused, current: current, duration: self.duration, title: self.dataDelegate?.title ?? "")
                    playerControl.delegate = self
                    playerControl.frame = self.bounds
                    playerControl.autoresizingMask = [.flexibleHeight, .flexibleWidth]
                    playerControl.beforeTransition()
                    UIView.transition(with: self, duration: 0.4, options: .transitionCrossDissolve, animations: {
                        self.addSubview(playerControl)
                        playerControl.runTransition()
                    }, completion: { _ in
                        self.setupPlayerControlTimer()
                    })
                }
            }
        }
    }
    
    func setupPlayerControlTimer() {
        playerControlTimer = Timer.scheduledTimer(withTimeInterval: 3, repeats: false, block: { _ in
            DispatchQueue.main.async {
                self.removePlayerControl(animated: true)
            }
        })
    }
    
    private var loaded = false
    
    private var videoId: VideoId = "0"
    
    private var requestToPlay = false
    
    private var bufferPlay = false
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var centerInLastWindow: CGPoint!
    
    var boundsInLastWindow: CGRect!
    
    var cell: RippleCellV2!
}

var yTPlayerView: WKYTPlayerView?
extension VideoWithPlayerView: WKYTPlayerViewDelegate {
    func playerView(_ playerView: WKYTPlayerView, didChangeTo state: WKYTPlayerState) {
        switch state {
        case .unstarted, .playing:
            beforeAppear()
        default:
            return
        }
    }
    
    func playerViewDidBecomeReady(_ playerView: WKYTPlayerView) {
        defer {
            videoView.getDuration { (duration, _) in
                self.duration = Float(duration)
                self.playerControl?.videoDidReady(duration: self.duration)
            }
        }
        
        if self.requestToPlay {
            play()
            return
        }
        
        if self.requestToBuffer {
            buffer()
            return
        }
    }
    
    func playerView(_ playerView: WKYTPlayerView, didPlayTime playTime: Float) {
        current = playTime
        playerControl?.didPlayedTo(playTime)
    }
}

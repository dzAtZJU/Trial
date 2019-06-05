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

class VideoWithPlayerView: UIView {
    let videoView: WKYTPlayerView
    
    private var playerControl: PlayerControlView?
    
    var screenshot: UIView?
    
    private var isFirstPlayed = true
    
    private var requestToBuffer = false
    
    var isReady = false
    
    static func loadVideoForWatch(videoId: VideoId) -> VideoWithPlayerView {
        let result = VideoWithPlayerView(videoId: videoId)
        result.setPlayerControl(PlayerControlView())
        return result
    }
    
    private init(videoId: VideoId) {
        videoView = WKYTPlayerView()
        super.init(frame: CGRect.zero)
        videoView.delegate = self
        setupSubview(videoView)
        self.videoId = videoId
        self.videoView.load(withVideoId: videoId, playerVars: ["controls":0, "playsinline":1, "start": 1, "modestbranding": 1])
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
    
    func pause() {
        self.requestToPlay = false
        self.videoView.isHidden = false
        activityIndicator.stopAnimating()
        videoView.pauseVideo()
    }
    
    private func beforeAppear() {
        activityIndicator.stopAnimating()
        isReady = true
        self.videoView.isHidden = false
        if requestToBuffer && !requestToPlay {
            endBuffer()
        }
    }
    
    private func setPlayerControl(_ playerControl: PlayerControlView) {
        self.playerControl = playerControl
        setupSubview(playerControl)
    }
    
    func getVideoState(_ block: @escaping (WKYTPlayerState) -> ()) {
        videoView.getPlayerState { (state, _) in
            block(state)
        }
    }
    
    private var loaded = false
    
    private var videoId: VideoId = "0"
    
    private var requestToPlay = false
    
    private var bufferPlay = false
    
    private func setupSubview(_ subView: UIView) {
        subView.frame = self.bounds
        subView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        addSubview(subView)
    }
    
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
        if self.requestToPlay {
            play()
            return
        }
        
        if self.requestToBuffer {
            buffer()
            return
        }
    }
}

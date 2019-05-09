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

class VideoWithPlayerView: UIView {
    let videoView: WKYTPlayerView
    
    private var playerControl: PlayerControlView?
    
    var screenshot: UIImage!
    
    private var isFirstPlayed = true
    
    private var requestToBuffer = false
    
    static func loadVideoForWatch(videoId: VideoId) -> VideoWithPlayerView {
        let result = VideoWithPlayerView(videoId: videoId)
        result.setPlayerControl(PlayerControlView())
        return result
    }
    
    private init(videoId: VideoId) {
        videoView = WKYTPlayerView()
        super.init(frame: CGRect.zero)
        backgroundColor = UIColor.purple
        videoView.delegate = self
        setupSubview(videoView)
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {
                return
            }
            self.videoId = videoId
            self.videoView.load(withVideoId: videoId, playerVars: ["controls":1, "playsinline":1, "start": 1, "modestbranding": 1])
        }
    }
    
    func play() {
        self.requestToPlay = true
        DispatchQueue.main.async {
            self.videoView.playVideo()
            self.isFirstPlayed = false
        }
    }
    
    func buffer() {
        self.requestToBuffer = true
        DispatchQueue.main.async {
          self.videoView.seek(toSeconds: 0, allowSeekAhead: true)
        }
    }
    
    func endBuffer() {
        requestToBuffer = false
        DispatchQueue.main.async {
            self.videoView.pauseVideo()
            self.window?.insertSubview(self, at: 0)
        }
    }
    
    /// Leave cell then pack up
    func fallOff(completion: ((VideoWithPlayerView) -> ())? = nil) {
        screenshot = snapshot()
        pause()
        window?.insertSubview(self, at: 0) // remove from super view will somehow clear up the video, so instead just move to elsewhere
        
        if let completion = completion {
            completion(self)
        }
    }
    
    func pause() {
        self.isHidden = true
        activityIndicator.stopAnimating()
        DispatchQueue.main.async { [weak self] in
            guard let theSelf = self else {
                return
            }
            theSelf.videoView.pauseVideo()
        }
    }
    
    private func beforeAppear() {
        activityIndicator.stopAnimating()
        isHidden = false
        if requestToBuffer && !requestToPlay {
            endBuffer()
        }
    }
    
    private func setPlayerControl(_ playerControl: PlayerControlView) {
        self.playerControl = playerControl
        setupSubview(playerControl)
    }
    
    lazy var renderer = UIGraphicsImageRenderer(size: CGSize(width: UIMetricTemplate.watch.itemWidth, height: UIMetricTemplate.watch.itemHeight))
    func snapshot() -> UIImage {
        return renderer.image { ctx in
            videoView.drawHierarchy(in: ctx.format.bounds, afterScreenUpdates: false)
        }
    }
    
    func getVideoState(_ block: @escaping (WKYTPlayerState) -> ()) {
        videoView.getPlayerState { (state, _) in
            print(state.rawValue)
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
        layer.borderWidth = 5
        switch state {
        case .unstarted:
            layer.borderColor = UIColor.gray.cgColor
            beforeAppear()
        case .queued:
            layer.borderColor = UIColor.yellow.cgColor
        case .buffering:
            layer.borderColor = UIColor.orange.cgColor
        case .playing:
            layer.borderColor = UIColor.green.cgColor
            beforeAppear()
        case .paused:
            layer.borderColor = UIColor.red.cgColor
        case .ended:
            layer.borderColor = UIColor.black.cgColor
        case .unknown:
            layer.borderColor = UIColor.blue.cgColor
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

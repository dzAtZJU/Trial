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

class VideoWithPlayerView: UIView {
    
    private let videoView: WKYTPlayerView
    
    private var playerControl: PlayerControlView?
    
    var screenshot: UIImage!
    
    /// Leave cell then pack up
    func fallOff() {
        window?.insertSubview(self, at: 0) // remove from super view will somehow clear up the video, so instead just move to elsewhere
        pause()
        screenshot = snapshot()
    }
    
    func play() {
        getVideoState { state in
            guard state != WKYTPlayerState.playing else {
                return
            }
            activityIndicator.startAnimating()
        }
        self.requestToPlay = true
        DispatchQueue.main.async { [weak self] in
            guard let theSelf = self else {
                return
            }
            theSelf.videoView.playVideo()
        }
    }
    
    func pause() {
        self.requestToPlay = false
        self.isHidden = true
        activityIndicator.stopAnimating()
        DispatchQueue.main.async { [weak self] in
            guard let theSelf = self else {
                return
            }
            theSelf.videoView.pauseVideo()
        }
    }
    
    lazy var renderer = UIGraphicsImageRenderer(size: CGSize(width: UIMetricTemplate.watch.itemWidth, height: UIMetricTemplate.watch.itemHeight))
    func snapshot() -> UIImage {
        return renderer.image { ctx in
            videoView.drawHierarchy(in: ctx.format.bounds, afterScreenUpdates: false)
        }
    }
    
    
    func getVideoState(_ block: @escaping (WKYTPlayerState) -> ()) {
        videoView.getPlayerState { (state, _) in
            block(state)
        }
    }
    
    static func loadVideoForWatch(videoId: VideoId) -> VideoWithPlayerView {
        let result = VideoWithPlayerView(videoId: videoId)
        result.setPlayerControl(PlayerControlView())
        return result
    }
    
    func setPlayerControl(_ playerControl: PlayerControlView) {
        self.playerControl = playerControl
        setupSubview(playerControl)
    }
    
    private init(videoId: VideoId) {
        videoView = WKYTPlayerView()
        super.init(frame: CGRect.zero)
        isHidden = true
        videoView.delegate = self
        setupSubview(videoView)
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {
                return
            }
            self.videoId = videoId
            self.loaded = self.videoView.load(withVideoId: videoId, playerVars: ["controls":0, "playsinline":1, "start": 1])
            self.playerControl?.label.text = self.videoId + "loaded: \(self.loaded)"
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
    
    var cell: RippleCell!
}

var yTPlayerView: WKYTPlayerView?
extension VideoWithPlayerView: WKYTPlayerViewDelegate {
    func playerView(_ playerView: WKYTPlayerView, didChangeTo state: WKYTPlayerState) {
        layer.borderWidth = 5
        switch state {
        case .unstarted:
            layer.borderColor = UIColor.gray.cgColor
        case .queued:
            layer.borderColor = UIColor.yellow.cgColor
        case .buffering:
            layer.borderColor = UIColor.orange.cgColor
        case .playing:
            layer.borderColor = UIColor.green.cgColor
            activityIndicator.stopAnimating()
            isHidden = false
        case .paused:
            layer.borderColor = UIColor.red.cgColor
        case .ended:
            layer.borderColor = UIColor.black.cgColor
        case .unknown:
            layer.borderColor = UIColor.blue.cgColor
        default:
            return
        }
        playerControl?.label.text = playerControl?.label.text ?? "" + "\(state)"
    }
    
    func playerViewDidBecomeReady(_ playerView: WKYTPlayerView) {
        if self.requestToPlay {
            play()
        }
    }
}

//extension YTPlayerView {
//    func fixWebViewLayout() {
//        webView!.scrollView.translatesAutoresizingMaskIntoConstraints = false
//        addConstraints([NSLayoutConstraint(item: webView!.scrollView, attribute: .bottom, relatedBy: .equal, toItem: webView, attribute: .bottom, multiplier: 1, constant: 0),
//                        NSLayoutConstraint(item: webView!.scrollView, attribute: .top, relatedBy: .equal, toItem: webView, attribute: .top, multiplier: 1, constant: 0),
//                        NSLayoutConstraint(item: webView!.scrollView, attribute: .leading, relatedBy: .equal, toItem: webView, attribute: .leading, multiplier: 1, constant: 0),
//                        NSLayoutConstraint(item: webView!.scrollView, attribute: .trailing, relatedBy: .equal, toItem: webView, attribute: .trailing, multiplier: 1, constant: 0)])
//    }
//}

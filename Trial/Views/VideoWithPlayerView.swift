//
//  VideoWithControlView.swift
//  Trial
//
//  Created by 周巍然 on 2019/3/28.
//  Copyright © 2019 周巍然. All rights reserved.
//

import Foundation
import UIKit
import youtube_ios_player_helper

class VideoWithPlayerView: UIView {
    
    var centerInLastWindow: CGPoint!
    var boundsInLastWindow: CGRect!
    
    static func createForInitialWatch(videoId: VideoId) -> VideoWithPlayerView {
        let result = VideoWithPlayerView(videoId: videoId)
        result.setPlayerControl(PlayerControlView())
        return result
    }
    
    let videoView: YTPlayerView
    var playerControl: PlayerControlView?

    init(videoId: VideoId) {
        videoView = YTPlayerView()
        super.init(frame: CGRect.zero)
        setupSubview(videoView)
    }
    
    private func setupSubview(_ subView: UIView) {
        subView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(subView)
        addConstraints([NSLayoutConstraint(item: subView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0),
                        NSLayoutConstraint(item: subView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0),
                        NSLayoutConstraint(item: subView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0),
                        NSLayoutConstraint(item: subView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0)])
    }
    
    func setPlayerControl(_ playerControl: PlayerControlView) {
        self.playerControl = playerControl
        setupSubview(playerControl)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension YTPlayerView {
    func fixWebViewLayout() {
        webView!.scrollView.translatesAutoresizingMaskIntoConstraints = false
        addConstraints([NSLayoutConstraint(item: webView!.scrollView, attribute: .bottom, relatedBy: .equal, toItem: webView, attribute: .bottom, multiplier: 1, constant: 0),
                        NSLayoutConstraint(item: webView!.scrollView, attribute: .top, relatedBy: .equal, toItem: webView, attribute: .top, multiplier: 1, constant: 0),
                        NSLayoutConstraint(item: webView!.scrollView, attribute: .leading, relatedBy: .equal, toItem: webView, attribute: .leading, multiplier: 1, constant: 0),
                        NSLayoutConstraint(item: webView!.scrollView, attribute: .trailing, relatedBy: .equal, toItem: webView, attribute: .trailing, multiplier: 1, constant: 0)])
    }
}

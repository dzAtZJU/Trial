//
//  VideoCellV2.swift
//  Trial
//
//  Created by 周巍然 on 2019/6/5.
//  Copyright © 2019 周巍然. All rights reserved.
//

import Foundation
import UIKit
import YoutubePlayer_in_WKWebView

class VideoCellV2: ThumbnailCell {
    
    private(set) var video: VideoWithPlayerView?
    
    var screenshot: UIView?
    
    var title: String?
    
    // mount, unmount 概念是基于交互来说的，在这里针对交互的要求来处理 video
    func mountVideo(_ video: VideoWithPlayerView, keepWatchingState: Bool = false, alpha: CGFloat = 1) {
        self.video = video
        
        addVideoToHierarchy(video)
        
        layoutIfNeeded()
        
        video.dataDelegate = self
        if !keepWatchingState {
            video.play()
        }
        video.alpha = alpha
        activityIndicator.startAnimating()
    }
    
    func unMountVideo() {
        guard let video = video else {
            return
        }
        
        defer {
            self.video = nil
        }

        video.eventDelegate = nil
        video.dataDelegate = nil
        
        guard video.isReady else {
            video.removeFromSuperview()
            return
        }

        video.fallOff()
        
        addScreenshotToHierarchy(video.screenshot)
    }
    
    // Subclassable
    func addVideoToHierarchy(_ video: VideoWithPlayerView) {}
    
    // Subclassable
    func addScreenshotToHierarchy(_ image: UIView?) {}
}

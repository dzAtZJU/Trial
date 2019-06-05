//
//  VideoCellV2.swift
//  Trial
//
//  Created by 周巍然 on 2019/6/5.
//  Copyright © 2019 周巍然. All rights reserved.
//

import Foundation
import UIKit

class VideoCellV2: ThumbnailCell {
    
    private(set) var video: VideoWithPlayerView?
    
    private(set) var screenshot: UIView?
    
    // mount, unmount 概念是基于交互来说的，在这里针对交互的要求来处理 video
    func mountVideo(_ video: VideoWithPlayerView) {
        defer {
            self.video = video
        }
        
        addVideoToHierarchy(video)
        layoutIfNeeded()
        
        video.videoView.isHidden = true
        video.play()
        activityIndicator.startAnimating()
    }
    
    func unMountVideo() {
        guard let video = video else {
            return
        }
        
        defer {
            self.video = nil
        }

        guard video.isReady else {
            video.removeFromSuperview()
            return
        }

        video.fallOff()
        
        addScreenshot(video.screenshot)
    }
    
    // Subclassable
    func addVideoToHierarchy(_ video: VideoWithPlayerView) {}
    
    // Subclassable
    func addScreenshot(_ image: UIView?) {}
}

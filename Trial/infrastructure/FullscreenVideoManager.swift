//
//  InFocusVideo.swift
//  Trial
//
//  Created by 周巍然 on 2019/5/28.
//  Copyright © 2019 周巍然. All rights reserved.
//

import Foundation
import UIKit

class FullscreenVideoManager {
    var video: VideoWithPlayerView?
    
    private init() {}
    
    static let current = FullscreenVideoManager()
    
    func gotoWindow(video: VideoWithPlayerView, window: UIView) {
        self.video = video
        deactivateLayout()
        
        video.frame = window.bounds
        window.addSubview(video)
    }
    
    func gotoCell() {
        reactivateLayout()
        video = nil
    }
    
    private func deactivateLayout() {
        self.video?.constraints.forEach { $0.isActive = false }
        self.video?.translatesAutoresizingMaskIntoConstraints = true
    }
    
    private func reactivateLayout() {
        self.video?.constraints.forEach { $0.isActive = true }
        self.video?.translatesAutoresizingMaskIntoConstraints = false
    }
}

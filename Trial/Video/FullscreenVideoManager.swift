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
    
    func gotoWindow(video: VideoWithPlayerView, window: UIWindow) {
        self.video = video
        window.addSubview(video)
    }
    
    func gotoCell(block: (VideoWithPlayerView) -> ()) {
        block(video!)
        video = nil
    }
}

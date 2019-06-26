//
//  TestVC.swift
//  Trial
//
//  Created by 周巍然 on 2019/5/8.
//  Copyright © 2019 周巍然. All rights reserved.
//

import Foundation
import UIKit
import WebKit
import CoreGraphics
import YoutubePlayer_in_WKWebView

class TestVC: UIViewController {

    override func viewDidLoad() {
        let v = VideoWithPlayerView.loadVideoForWatch(videoId: "876pLueclwE")
        v.frame = view.bounds
        view.addSubview(v)
        v.isUserInteractionEnabled = true
        v.play()
    }
}

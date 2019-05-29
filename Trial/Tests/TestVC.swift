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
    var web: WKWebView!
    var aView: UIView!
    var count = 0
    var link: CADisplayLink!
    let animator = UIViewPropertyAnimator(duration: 4, curve: UIView.AnimationCurve.easeInOut, animations: nil)
 
    override func viewDidLoad() {
        view.backgroundColor = UIColor.yellow
//        let videoView = WKYTPlayerView(frame: CGRect(origin: .zero, size: CGSize(width: 375, height: 300)))
//        view.addSubview(videoView)
//        videoView.load(withVideoId: "qr21Mxcih2Y", playerVars: ["controls":1, "playsinline":1, "start": 1, "modestbranding": 1])
        
//        let videoPlayer = YouTubePlayerView(frame: CGRect(origin: .zero, size: CGSize(width: 375, height: 300)))
//        videoPlayer.playerVars["playsinline"] = NSString(string: "1")
//        view.addSubview(videoPlayer)
//        videoPlayer.loadVideoID("nuw6TLOEm7Q")
        aView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 50, height: 50)))
        aView.backgroundColor = UIColor.black
        view.addSubview(aView)

        let button = UIButton(frame: CGRect(origin: CGPoint(x: 180, y: 400), size: CGSize(width: 100, height: 100)))
        button.backgroundColor = UIColor.blue
        button.addTarget(self, action: #selector(handleButton), for: .touchUpInside)
        view.addSubview(button)
    }
    
    @objc func handleButton() {
        if count == 0 {
            self.count = 1
            animator.addAnimations {
                 self.aView.center = CGPoint(x: 100, y: 25)
            }
            animator.startAnimation()
        } else if count == 1 {
            count = 2
            animator.pauseAnimation()
            animator.continueAnimation(withTimingParameters: nil, durationFactor: 0.1)
//            animator.addAnimations({
//                self.aView.bounds = CGRect(origin: .zero, size: CGSize(width: 100, height: 100))
//            }, delayFactor: 0.5)
        } else {
            count = 0
            self.aView.center = CGPoint(x: 25, y: 25)
            animator.stopAnimation(true)
            animator.finishAnimation(at: UIViewAnimatingPosition.end)
        }

    }
}

//
//  VideoViewController.swift
//  Trial
//
//  Created by 周巍然 on 2019/3/14.
//  Copyright © 2019 周巍然. All rights reserved.
//

import Foundation
import UIKit
import youtube_ios_player_helper

class VideoViewController: UIViewController {
    
    @IBOutlet weak var close: UIButton!
    
    var ytPlayerView: YTPlayerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.layer.cornerRadius = view.bounds.width / ratioOfcornerRadiusAndWidth
        close.layer.cornerRadius = close.bounds.width / ratioOfcornerRadiusAndWidth
        close.addTarget(self, action: #selector(closeVideo), for: .touchUpInside)
        self.modalPresentationStyle = .custom
        self.transitioningDelegate = self
        
//        ytPlayerView = YTPlayerView(frame: CGRect(x: 0, y: 0, width: 150, height: 250))
//        view.addSubview(ytPlayerView)
//        ytPlayerView.load(videoId: "_uk4KXP8Gzw", playerVars: ["controls":0, "playsinline":1])
    }
    
    @objc func closeVideo() {
        dismiss(animated: true, completion: nil)
    }
}

extension VideoViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if let presenting = presenting as? AnimationExpanding, let _ = presented as? VideoViewController {
            return ViewControllerAnimatedTransitioning(initialFrame: presenting.initialFrame, duration: 0.5)
        }
        return nil
    }
}

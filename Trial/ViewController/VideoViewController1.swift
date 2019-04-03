//
//  VideoViewController.swift
//  Trial
//
//  Created by 周巍然 on 2019/3/14.
//  Copyright © 2019 周巍然. All rights reserved.
//

import Foundation
import UIKit
import YoutubePlayer_in_WKWebView

class VideoViewController: UIViewController {
    
    @IBOutlet weak var close: UIButton!
    
    var videoWithPlayer: VideoWithPlayerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.layer.cornerRadius = view.bounds.width / ratioOfcornerRadiusAndWidth
        close.layer.cornerRadius = close.bounds.width / ratioOfcornerRadiusAndWidth
        close.addTarget(self, action: #selector(closeVideo), for: .touchUpInside)
        self.modalPresentationStyle = .custom
        self.transitioningDelegate = self
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @objc func closeVideo() {
        dismiss(animated: true, completion: nil)
    }
    
    func addVideoWithPlayer(_ videoWithPlayer: VideoWithPlayerView) {
        self.videoWithPlayer = videoWithPlayer
        videoWithPlayer.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        videoWithPlayer.transform = CGAffineTransform(rotationAngle: .pi / 2)
        videoWithPlayer.center = view.center
        videoWithPlayer.bounds = CGRect(x: 0, y: 0, width: view.bounds.height, height: view.bounds.width)
        view.insertSubview(videoWithPlayer, belowSubview: close)
    }
}

extension VideoViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if let presenting = presenting as? RippleVC {
            let cellInFocus = presenting.inFocusCell
            let video = cellInFocus.videoWithPlayer!
    
            let center = video.convert(CGPoint(x: video.frame.midX, y: video.frame.midY), to: nil)
            let size = cellInFocus.bounds.size
            
            video.boundsInLastWindow = CGRect(origin: .zero, size: size)
            video.centerInLastWindow = center
            let image = video.snapshotView(afterScreenUpdates: true)!
            return RotatedPresentTransitioning(startView: image, centerInWindow: center, startSize: size)
        }
        return nil
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if let presenting = dismissed.presentingViewController as? RippleVC, let presented = dismissed as? VideoViewController {
            let cellInFocus = presenting.inFocusCell
            let imageView = cellInFocus.imageView!
            let center = imageView.convert(CGPoint(x: imageView.bounds.midX, y: imageView.bounds.midY), to: nil)
            
            let image = presented.videoWithPlayer.snapshotView(afterScreenUpdates: true)!
            return RotatedDismissTransitioning(startView: image, centerInWindow: center, bounds: cellInFocus.bounds)
        }
        return nil
    }
}

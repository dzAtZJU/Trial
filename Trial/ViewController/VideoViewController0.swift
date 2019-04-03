////
////  VideoViewController.swift
////  Trial
////
////  Created by 周巍然 on 2019/3/14.
////  Copyright © 2019 周巍然. All rights reserved.
////
//
//import Foundation
//import UIKit
//import youtube_ios_player_helper
//
//class VideoViewController: UIViewController {
//
//    @IBOutlet weak var close: UIButton!
//
//    var videoWithPlayer: VideoWithPlayerView!
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        print("w:\(view.frame.width) h:\(view.frame.height)")
//        view.layer.cornerRadius = view.bounds.width / ratioOfcornerRadiusAndWidth
//        close.layer.cornerRadius = close.bounds.width / ratioOfcornerRadiusAndWidth
//        close.addTarget(self, action: #selector(closeVideo), for: .touchUpInside)
//        self.modalPresentationStyle = .custom
//        self.transitioningDelegate = self
//    }
//
//    @objc func closeVideo() {
//        dismiss(animated: true, completion: nil)
//    }
//
//    func addVideoWithPlayer(_ videoWithPlayer: VideoWithPlayerView) {
//        self.videoWithPlayer = videoWithPlayer
//        videoWithPlayer.autoresizingMask = [.flexibleHeight, .flexibleWidth]
//        view.insertSubview(videoWithPlayer, belowSubview: close)
//    }
//}
//
//extension VideoViewController: UIViewControllerTransitioningDelegate {
//
//    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        if let presenting = presenting as? RippleVC {
//            let cellInFocus = presenting.inFocusCell
//
//            let video = cellInFocus.videoWithPlayer!
//            video.cell = cellInFocus
//
//            let center = video.convert(CGPoint(x: video.frame.midX, y: video.frame.midY), to: nil)
//
//            let image = snapshotImage(with: cellInFocus)!
//            return RotatedPresentTransitioning(startView: video, centerInWindow: center)
//        }
//        return nil
//    }
//
//    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        if let presenting = dismissed.presentingViewController as? RippleVC {
//            let cellInFocus = presenting.inFocusCell
//            let frame = cellInFocus.frame
//            let center = cellInFocus.superview!.convert(CGPoint(x: frame.midX, y: frame.midY), to: nil)
//            return RotatedDismissTransitioning(startView: (dismissed as! VideoViewController).videoWithPlayer, bounds: cellInFocus.bounds, centerInWindow: center)
//        }
//        return nil
//    }
//}

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
//import YoutubePlayer_in_WKWebView
//
//extension VideoViewController {
//    /// One place to configure timing contents
//    func handleUserLeave() {
//        guard rippleViewStore.state.scene == .watching else {
//            return
//        }
//        videoWithPlayer.fallOff()
//        self.videoWithPlayer = nil
//    }
//    
//    func play() {
//        videoWithPlayer.play()
//    }
//    
//    func embedYTPlayer() {
//        videoWithPlayer.autoresizingMask = [.flexibleHeight, .flexibleWidth]
//        videoWithPlayer.frame = view.bounds
//        view.insertSubview(videoWithPlayer, belowSubview: close)
//    }
//}
//
//class VideoViewController: UIViewController {
//    
//    @IBOutlet weak var close: UIButton!
//    
//    var videoWithPlayer: VideoWithPlayerView!
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.layer.cornerRadius = view.bounds.width / ratioOfcornerRadiusAndWidth
//        close.layer.cornerRadius = close.bounds.width / ratioOfcornerRadiusAndWidth
//        close.addTarget(self, action: #selector(closeVideo), for: .touchUpInside)
//        modalPresentationStyle = .overFullScreen
//        self.modalPresentationStyle = .custom
//        self.transitioningDelegate = self
//    }
//    
//    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
//        return [.landscapeLeft, .landscapeRight]
//    }
//    
//    override var prefersStatusBarHidden: Bool {
//        return true
//    }
//    
//    @objc func closeVideo() {
//        dismiss(animated: true, completion: nil)
//    }
//    
//    func prepareForPresent(video: VideoWithPlayerView) {
//        self.videoWithPlayer = video
//    }
//}
//
//extension VideoViewController: UIViewControllerTransitioningDelegate {
//    
//    private struct CustomProperties {
//        static var birthCenter = 0
//        static var birthSize = 0
//    }
//    
//    private var birthCenter: CGPoint {
//        get {
//            return objc_getAssociatedObject(self, &CustomProperties.birthCenter) as! CGPoint
//        }
//        set {
//            objc_setAssociatedObject(self, &CustomProperties.birthCenter, newValue, .OBJC_ASSOCIATION_COPY)
//        }
//    }
//    
//    private var birthSize: CGSize {
//        get {
//            return objc_getAssociatedObject(self, &CustomProperties.birthSize) as! CGSize
//        }
//        set {
//            objc_setAssociatedObject(self, &CustomProperties.birthSize, newValue, .OBJC_ASSOCIATION_COPY)
//        }
//    }
//    
//    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        if let presenting = presenting as? RippleVC {
//            let cellInFocus = presenting.inFocusCell!
//
//            let center = cellInFocus.superview!.convert(cellInFocus.frame.center, to: nil)
//            let size = cellInFocus.bounds.size
//
//            birthCenter = center
//            birthSize = size
//
//            if presenting.traitCollection.verticalSizeClass == .regular {
//                return RotatedPresentTransition(startImage: videoWithPlayer.screenshot, centerInWindow: center, startSize: size)
//            } else {
//                return ScalePresentTransition(startImage: videoWithPlayer.screenshot, centerInWindow: center, startSize: size)
//            }
//        }
//        return nil
//    }
//
//    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        if let presenting = dismissed.presentingViewController as? RippleVC, let presented = dismissed as? VideoViewController {
//            presented.videoWithPlayer.fallOff()
//            let image = presented.videoWithPlayer.screenshot!
////            if presenting.traitCollection.verticalSizeClass == .regular {
//                return RotatedDismissTransition(startImage: image, centerInWindow: birthCenter, startSize: birthSize)
////            } else {
////                return nil//ScaleDismissTransition(startImage: image, centerInWindow: birthCenter, startSize: birthSize)
////            }
//        }
//        return nil
//    }
//}

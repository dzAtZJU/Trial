////
////  Rotate.swift
////  Trial
////
////  Created by 周巍然 on 2019/3/26.
////  Copyright © 2019 周巍然. All rights reserved.
////
//
//import Foundation
//import UIKit
//
//class RotatedPresentTransitioning: NSObject, UIViewControllerAnimatedTransitioning {
//    
//    let startView: VideoWithPlayerView
//    
//    let startCenterInWindow: CGPoint
//    
//    let duration: Double = 1
//    
//    init(startView: VideoWithPlayerView, centerInWindow: CGPoint) {
//        self.startView = startView
//        self.startCenterInWindow = centerInWindow
//        
//        startView.centerInLastWindow = centerInWindow
//        startView.boundsInLastWindow = startView.bounds
//    }
//    
//    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
//        return duration
//    }
//    
//    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
//        let startBounds = startView.bounds
//        startView.removeFromSuperview()
//        
//        startView.bounds = startBounds
//        startView.center = startCenterInWindow
//        
//        let canvas = transitionContext.containerView
//        canvas.addSubview(startView)
//        
//        let toView = transitionContext.view(forKey: .to)!
//        toView.isHidden = true
//        canvas.addSubview(toView)
//        
//        UIView.animate(withDuration: duration, animations: {
//            let finaleFrame = transitionContext.finalFrame(for: transitionContext.viewController(forKey: .to)!)
//            self.startView.bounds = CGRect(x: 0, y: 0, width: finaleFrame.height, height: finaleFrame.width)
//            self.startView.center = CGPoint(x: finaleFrame.midX, y: finaleFrame.midY)
//            self.startView.layoutIfNeeded()
//            self.startView.transform = CGAffineTransform(rotationAngle: .pi / 2)
//        }, completion: { finished in
//            transitionContext.completeTransition(finished)
//            toView.isHidden = false
//            self.startView.removeFromSuperview()
//            (transitionContext.viewController(forKey: .to) as! VideoViewController).addVideoWithPlayer(self.startView)
//        })
//    }
//}
//
//class RotatedDismissTransitioning: NSObject, UIViewControllerAnimatedTransitioning {
//    
//    let bounds: CGRect
//    
//    let centerInWindow: CGPoint
//    
//    let duration: Double = 1
//    
//    let startView: VideoWithPlayerView
//    
//    init(startView: VideoWithPlayerView, bounds: CGRect, centerInWindow: CGPoint) {
//        self.bounds = bounds
//        self.centerInWindow = centerInWindow
//        self.startView = startView
//    }
//    
//    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
//        return duration
//    }
//    
//    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
//        let fromView = transitionContext.view(forKey: .from)!
//        fromView.isHidden = true
//        fromView.removeFromSuperview()
//        
//        let canvas = transitionContext.containerView
//        canvas.addSubview(transitionContext.view(forKey: .to)!)
//        
//        startView.videoView.webView?.backgroundColor = UIColor.red
//        startView.removeFromSuperview()
//        startView.bounds = CGRect(x: 0, y: 0, width: fromView.bounds.height, height: fromView.bounds.width)
//        startView.center = CGPoint(x: fromView.bounds.midX, y: fromView.bounds.midY)
//        self.startView.transform = CGAffineTransform(rotationAngle: .pi / 2)
//        self.startView.layoutIfNeeded()
//        startView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
//        
//        canvas.addSubview(startView)
//        
//        UIView.animate(withDuration: duration, animations: {
//            let finalBounds = self.startView.boundsInLastWindow!
//            let startBounds = self.startView.bounds
//            self.startView.center = self.startView.centerInLastWindow
//            self.startView.bounds = finalBounds
//            self.startView.transform = CGAffineTransform.identity
//            self.startView.layoutIfNeeded()
//        }, completion: { finished in
//            transitionContext.completeTransition(finished)
//            self.startView.removeFromSuperview()
//            self.startView.cell.embedYTPlayer(self.startView)
//        })
//    }
//    
//    
//}

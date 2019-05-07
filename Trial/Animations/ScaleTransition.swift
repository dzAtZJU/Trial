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
//class ScalePresentTransition: NSObject, UIViewControllerAnimatedTransitioning {
//    
//    let startImage: UIImage
//    
//    let startCenterInWindow: CGPoint
//    
//    let startSize: CGSize
//    
//    let duration: Double = 3
//    
//    init(startImage: UIImage, centerInWindow: CGPoint, startSize: CGSize) {
//        self.startImage = startImage
//        self.startCenterInWindow = centerInWindow
//        self.startSize = startSize
//    }
//    
//    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
//        return duration
//    }
//    
//    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
//        let canvas = transitionContext.containerView
//        
//        let toVC = transitionContext.viewController(forKey: .to) as! VideoViewController
//        toVC.embedYTPlayer()
//        let toView = transitionContext.view(forKey: .to)!
//        toView.isHidden = true
//        canvas.addSubview(toView)
//        
//        let startView = UIImageView(image: startImage)
//        startView.bounds = CGRect(origin: CGPoint.zero, size: startSize)
//        startView.center = startCenterInWindow
//        canvas.addSubview(startView)
//        
//        UIView.animate(withDuration: duration, animations: {
//            let finaleFrame = transitionContext.finalFrame(for: transitionContext.viewController(forKey: .to)!)
//            startView.bounds = finaleFrame
//        }, completion: { finished in
//            toView.isHidden = false
//            toVC.play()
//            startView.removeFromSuperview()
//            transitionContext.completeTransition(finished)
//        })
//    }
//}
//
//class ScaleDismissTransition: NSObject, UIViewControllerAnimatedTransitioning {
//    
//    let startSize: CGSize
//    
//    let centerInWindow: CGPoint
//    
//    let duration: Double = 3
//    
//    let startImage: UIImage
//    
//    init(startImage: UIImage, centerInWindow: CGPoint, startSize: CGSize) {
//        self.startSize = startSize
//        self.centerInWindow = centerInWindow
//        self.startImage = startImage
//    }
//    
//    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
//        return duration
//    }
//    
//    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
//        let canvas = transitionContext.containerView
//        let toView = transitionContext.view(forKey: .to)!
//        let toVC = transitionContext.viewController(forKey: .to) as! RippleVC
//        let fromVC = transitionContext.viewController(forKey: .from) as! VideoViewController
//        toVC.inFocusCell!.embedYTPlayer(fromVC.videoWithPlayer)
//        canvas.addSubview(toView)
//        
//        let fromView = transitionContext.view(forKey: .from)!
//        fromView.removeFromSuperview()
//        
//        let startView = UIImageView(image: startImage)
//        startView.frame = fromView.bounds
//        canvas.addSubview(startView)
//        
//        UIView.animate(withDuration: duration, animations: {
//            startView.center = self.centerInWindow
//            startView.bounds = CGRect(origin: .zero, size: self.startSize)
//        }, completion: { finished in
//            startView.removeFromSuperview()
//            toVC.inFocusCell!.play()
//            transitionContext.completeTransition(finished)
//        })
//    }
//    
//    
//}

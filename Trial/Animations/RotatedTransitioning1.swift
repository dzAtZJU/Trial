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
//class RotatedPresentTransition: NSObject, UIViewControllerAnimatedTransitioning {
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
//        let startView = UIImageView(image: startImage)
//        startView.contentMode = .scaleAspectFill
//        startView.bounds = CGRect(origin: CGPoint.zero, size: startSize)
//        startView.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
//        let canvas = transitionContext.containerView
//        startView.center = canvas.bounds.center
//        canvas.addSubview(startView)
//        
//        let toVC = transitionContext.viewController(forKey: .to) as! VideoViewController
//        toVC.embedYTPlayer()
//        let toView = transitionContext.view(forKey: .to)!
//        toView.isHidden = true
//        toView.frame = canvas.bounds
//        canvas.addSubview(toView)
//        
//        UIView.animate(withDuration: duration, animations: {
//            startView.bounds = canvas.bounds
//            startView.transform = .identity
//        }, completion: { finished in
//            toVC.play()
//            toView.isHidden = false
//            startView.removeFromSuperview()
//            transitionContext.completeTransition(finished)
//        })
//    }
//}
//
//class RotatedDismissTransition: NSObject, UIViewControllerAnimatedTransitioning {
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
//        
//        
//        let toVC = transitionContext.viewController(forKey: .to) as! RippleVC
//        let fromVC = transitionContext.viewController(forKey: .from) as! VideoViewController
//        toVC.inFocusCell!.embedYTPlayer(fromVC.videoWithPlayer)
//        let toView = transitionContext.view(forKey: .to)!
//        toView.frame = canvas.bounds
//        canvas.addSubview(toView)
//        
//        let fromView = transitionContext.view(forKey: .from)!
//        fromView.removeFromSuperview()
//        
//        let startView = UIImageView(image: startImage)
//        startView.contentMode = .scaleAspectFill
//        startView.bounds = canvas.bounds
//        startView.center = canvas.bounds.center
//        startView.transform = CGAffineTransform(rotationAngle: .pi / -2)
//        canvas.addSubview(startView)
//        
//        UIView.animate(withDuration: duration, animations: {
//            startView.center = self.centerInWindow
//            startView.bounds = CGRect(origin: .zero, size: self.startSize)
//            startView.transform = CGAffineTransform.identity
//            startView.layoutIfNeeded()
//        }, completion: { finished in
//            transitionContext.completeTransition(finished)
//            startView.removeFromSuperview()
//        })
//    }
//    
//    
//}

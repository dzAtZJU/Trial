//
//  Rotate.swift
//  Trial
//
//  Created by 周巍然 on 2019/3/26.
//  Copyright © 2019 周巍然. All rights reserved.
//

import Foundation
import UIKit

class RotatedPresentTransitioning: NSObject, UIViewControllerAnimatedTransitioning {
    
    let startView: UIView
    
    let startCenterInWindow: CGPoint
    
    let startSize: CGSize
    
    let duration: Double = 0.3
    
    init(startView: UIView, centerInWindow: CGPoint, startSize: CGSize) {
        self.startView = startView
        self.startCenterInWindow = centerInWindow
        self.startSize = startSize
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        startView.bounds = CGRect(origin: CGPoint.zero, size: startSize)
        startView.center = startCenterInWindow
        let canvas = transitionContext.containerView
        canvas.addSubview(startView)
        
        let fromVC = transitionContext.viewController(forKey: .from) as! RippleVC
        (transitionContext.viewController(forKey: .to) as! VideoViewController).addVideoWithPlayer(fromVC.video)
        let toView = transitionContext.view(forKey: .to)!
        toView.isHidden = true
        canvas.addSubview(toView)
        
        UIView.animate(withDuration: duration, animations: {
            let finaleFrame = transitionContext.finalFrame(for: transitionContext.viewController(forKey: .to)!)
            self.startView.bounds = CGRect(x: 0, y: 0, width: finaleFrame.height, height: finaleFrame.width)
            self.startView.center = CGPoint(x: finaleFrame.midX, y: finaleFrame.midY)
            self.startView.layoutIfNeeded()
            self.startView.transform = CGAffineTransform(rotationAngle: .pi / 2)
        }, completion: { finished in
            toView.isHidden = false
            self.startView.removeFromSuperview()
            transitionContext.completeTransition(finished)
        })
    }
}

class RotatedDismissTransitioning: NSObject, UIViewControllerAnimatedTransitioning {
    
    let bounds: CGRect
    
    let centerInWindow: CGPoint
    
    let duration: Double = 0.3
    
    let startView: UIView
    
    init(startView: UIView, centerInWindow: CGPoint, bounds: CGRect) {
        self.bounds = bounds
        self.centerInWindow = centerInWindow
        self.startView = startView
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let canvas = transitionContext.containerView
        let toView = transitionContext.view(forKey: .to)!
        let toVC = transitionContext.viewController(forKey: .to) as! RippleVC
        let fromVC = transitionContext.viewController(forKey: .from) as! VideoViewController
        toVC.inFocusCell!.embedYTPlayer(fromVC.videoWithPlayer)
        canvas.addSubview(toView)
        
        let fromView = transitionContext.view(forKey: .from)!
        fromView.removeFromSuperview()
        
        startView.bounds = CGRect(x: 0, y: 0, width: fromView.bounds.height, height: fromView.bounds.width)
        startView.center = CGPoint(x: fromView.bounds.midX, y: fromView.bounds.midY)
        self.startView.transform = CGAffineTransform(rotationAngle: .pi / 2)
        canvas.addSubview(startView)
        
        UIView.animate(withDuration: duration, animations: {
            self.startView.center = fromVC.videoWithPlayer.centerInLastWindow
            self.startView.bounds = fromVC.videoWithPlayer.boundsInLastWindow
            self.startView.transform = CGAffineTransform.identity
            self.startView.layoutIfNeeded()
        }, completion: { finished in
            transitionContext.completeTransition(finished)
            self.startView.removeFromSuperview()
        })
    }
    
    
}
